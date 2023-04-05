import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/models/message_model.dart';
import 'package:instagram/models/messages_model.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/storage_service.dart';
import 'package:instagram/utils/update_user_data.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  // create a post
  Future<String> createPost(
    String uid,
    String username,
    String profileImage,
    Uint8List file,
    String description,
  ) async {
    String res = '';

    try {
      String postId = const Uuid().v1();
      String postUrl =
          await StorageService().uploadFileToStorage('posts', file, true);

      PostModel post = PostModel(
        uid: uid,
        postId: postId,
        username: username,
        profileImage: profileImage,
        postUrl: postUrl,
        likes: [],
        description: description,
        datePublished: FieldValue.serverTimestamp(),
      );

      await db.collection('posts').doc(postId).set(post.toJson());

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      await db.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // like a post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await db.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await db.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // follow / unfollow a user
  Future<void> follow(String uid, String followId) async {
    DocumentSnapshot snap = await db.collection('users').doc(uid).get();
    List following = (snap.data() as dynamic)!['following'];

    try {
      if (following.contains(followId)) {
        await db.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await db.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });

        await db
            .collection('following')
            .doc(uid)
            .collection('posts')
            .doc(followId)
            .delete();
      } else {
        await db.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await db.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });

        await db
            .collection('following')
            .doc(uid)
            .collection('posts')
            .doc(followId)
            .set({});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // post a comment
  Future<void> postComment(
    String uid,
    String postId,
    String profileImage,
    String username,
    String text,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await db
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'uid': uid,
            'commentId': commentId,
            'profileImage': profileImage,
            'username': username,
            'text': text,
            'createdAt': DateTime.now(),
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    await db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // update user profile
  Future<void> updateProfile(
    BuildContext context,
    Uint8List image,
    String name,
    String username,
  ) async {
    String imageUrl = await StorageService()
        .uploadFileToStorage('profileImages', image, false);

    await db.collection('users').doc(auth.currentUser!.uid).update({
      'imageUrl': imageUrl,
      'fullName': name,
      'username': username,
    });

    await updateUserDataInCollection('posts', {
      'profileImage': imageUrl,
      'username': username,
    });
  }

  void _saveDataOnMessageScreen(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    var receiverUserChat = MessagesModel(
      username: senderUserData.username,
      fullName: senderUserData.fullName,
      profilePicture: senderUserData.imageUrl,
      chatId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await db
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverUserChat.toMap(),
        );

    var senderUserChat = MessagesModel(
      username: receiverUserData.username,
      fullName: receiverUserData.fullName,
      profilePicture: receiverUserData.imageUrl,
      chatId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderUserChat.toMap(),
        );
  }

  void _saveDataOnChatScreen(
    String receiverUserId,
    String text,
    DateTime timeSent,
    String messageId,
    String senderUsername,
    String receiverUsername,
    String senderImageUrl,
  ) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      senderImageUrl: senderImageUrl,
      text: text,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    await db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await db
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  // send message
  void sendMessage({
    required String text,
    required String receiverId,
    required UserModel sender,
  }) async {
    try {
      final messageId = const Uuid().v1();
      var timeSent = DateTime.now();
      UserModel receiverData;
      var userDataMap = await db.collection('users').doc(receiverId).get();
      receiverData = UserModel.fromMap(userDataMap.data()!);

      _saveDataOnMessageScreen(
        sender,
        receiverData,
        text,
        timeSent,
        receiverId,
      );

      _saveDataOnChatScreen(
        receiverId,
        text,
        timeSent,
        messageId,
        sender.username,
        receiverData.username,
        sender.imageUrl,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
