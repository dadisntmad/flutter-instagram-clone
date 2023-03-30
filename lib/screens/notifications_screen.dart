import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/services/firestore_service.dart';
import 'package:instagram/widgets/custom_button.dart';
import 'package:instagram/widgets/loader.dart';
import 'package:instagram/widgets/profile_image.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Suggested for you',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: db.collection('users').where('uid',
            whereNotIn: ['followers', auth.currentUser!.uid]).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final user = snapshot.data!.docs[index];
              bool isFollowing = user['followers'].contains(
                auth.currentUser!.uid,
              );

              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: user['uid'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              ProfileImage(
                                imageUrl: user['imageUrl'],
                                size: 35,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user['username']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (user['fullName'] != '')
                                    Text(
                                      '${user['fullName']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          width: 70,
                          height: 25,
                          label: isFollowing ? 'Unfollow' : 'Follow',
                          color: accentBlue,
                          textColor: Colors.white,
                          isLoading: false,
                          onTap: () async {
                            await FirestoreService().follow(
                              auth.currentUser!.uid,
                              user['uid'],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
