import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String imageUrl;
  final String fullName;
  final List following;
  final List followers;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.fullName,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'imageUrl': imageUrl,
        'fullName': fullName,
        'following': following,
        'followers': followers,
      };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snap['uid'],
      username: snap['username'],
      email: snap['email'],
      imageUrl: snap['imageUrl'],
      fullName: snap['fullName'],
      following: snap['following'],
      followers: snap['followers'],
    );
  }
}
