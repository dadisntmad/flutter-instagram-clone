import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_card.dart';

class PostDetailedScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;

  const PostDetailedScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              '${snap['username']}'.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Posts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: PostCard(
          snap: snap,
        ),
      ),
    );
  }
}
