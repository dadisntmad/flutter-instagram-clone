import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/services/storage_service.dart';
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
}
