import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/messages_screen.dart';
import 'package:instagram/widgets/loader.dart';
import 'package:instagram/widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SvgPicture.asset(
          'assets/logo.svg',
          color: Colors.black,
          width: 30,
          height: 30,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MessagesScreen.route());
            },
            icon: Image.asset('assets/messenger.png', width: 24, height: 24),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db
            .collection('following')
            .doc(auth.currentUser!.uid)
            .collection('posts')
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          final following = snapshot.data!.docs.map((doc) => doc.id).toList();

          if (following.isEmpty) {
            return const SizedBox.shrink();
          }
          return FutureBuilder(
            future: db
                .collection('posts')
                .where('uid', whereIn: following)
                .orderBy('datePublished', descending: true)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    postSnapshot) {
              if (postSnapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return ListView.builder(
                itemExtent: 670,
                itemCount: postSnapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = postSnapshot.data!.docs[index];

                  return PostCard(postId: post['postId']);
                },
              );
            },
          );
        },
      ),
    );
  }
}
