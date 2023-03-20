import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/post_detailed_screen.dart';
import 'package:instagram/widgets/custom_button.dart';
import 'package:instagram/widgets/profile_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection('users').doc(auth.currentUser!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot userSnapshot) {
        return StreamBuilder(
          stream: db
              .collection('posts')
              .where('uid', isEqualTo: auth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> postSnapshot) {
            final user = userSnapshot.data!;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  '${user['username']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const ProfileImage(size: 65),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    userStatistics(
                                      postSnapshot.data!.docs.length,
                                      postSnapshot.data!.docs.length == 1
                                          ? 'Post'
                                          : 'Posts',
                                    ),
                                    userStatistics(
                                      user['followers'].length,
                                      user['following'].length == 1
                                          ? 'Follower'
                                          : 'Followers',
                                    ),
                                    userStatistics(
                                      user['following'].length,
                                      'Following',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          if (user['fullName'] != '')
                            Text(
                              user['fullName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  width: 100,
                                  height: 30,
                                  label: 'Edit Profile',
                                  color: accentGrey,
                                  textColor: Colors.black,
                                  isLoading: false,
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: CustomButton(
                                  width: 100,
                                  height: 30,
                                  label: 'Sign Out',
                                  color: accentGrey,
                                  textColor: Colors.black,
                                  isLoading: false,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      crossAxisCount: 3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final post = postSnapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PostDetailedScreen(
                                  snap: post,
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            post['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      childCount: postSnapshot.data!.docs.length,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Column userStatistics(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
    ],
  );
}
