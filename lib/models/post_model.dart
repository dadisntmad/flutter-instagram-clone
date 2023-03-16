import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String postId;
  final String username;
  final String profileImage;
  final String postUrl;
  final List likes;
  final String description;
  final datePublished;

  PostModel({
    required this.uid,
    required this.postId,
    required this.username,
    required this.profileImage,
    required this.postUrl,
    required this.likes,
    required this.description,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'postId': postId,
        'username': username,
        'profileImage': profileImage,
        'postUrl': postUrl,
        'likes': likes,
        'description': description,
        'datePublished': datePublished,
      };

  static PostModel fromSnap(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return PostModel(
      uid: snap['uid'],
      postId: snap['postId'],
      username: snap['username'],
      profileImage: snap['profileImage'],
      postUrl: snap['postUrl'],
      likes: snap['likes'],
      description: snap['description'],
      datePublished: snap['datePublished'],
    );
  }
}
