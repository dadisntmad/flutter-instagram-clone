import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/post_detailed_screen.dart';
import 'package:instagram/screens/signin_screen.dart';
import 'package:instagram/services/auth_service.dart';
import 'package:instagram/services/firestore_service.dart';
import 'package:instagram/utils/pick_image.dart';
import 'package:instagram/widgets/custom_button.dart';
import 'package:instagram/widgets/loader.dart';
import 'package:instagram/widgets/profile_image.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection('users').doc(uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        return StreamBuilder(
          stream: db
              .collection('posts')
              .where('uid', isEqualTo: uid)
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> postSnapshot) {
            if (postSnapshot.hasData) {
              final user = userSnapshot.data;

              final isFollowing = user!['followers'].contains(
                auth.currentUser!.uid,
              );

              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: auth.currentUser?.uid == uid
                      ? null
                      : const BackButton(color: Colors.black),
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
                                ProfileImage(
                                  imageUrl: user['imageUrl'],
                                  size: 65,
                                ),
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
                                        user!['followers'].length,
                                        user!['followers'].length == 1
                                            ? 'Follower'
                                            : 'Followers',
                                      ),
                                      userStatistics(
                                        user!['following'].length,
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
                              children: auth.currentUser?.uid == uid
                                  ? [
                                      Expanded(
                                        child: CustomButton(
                                          width: 100,
                                          height: 30,
                                          label: 'Edit Profile',
                                          color: accentGrey,
                                          textColor: Colors.black,
                                          isLoading: false,
                                          onTap: () {
                                            showModalBottomSheet(
                                              useSafeArea: true,
                                              isScrollControlled: true,
                                              isDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return _EditProfile(user: user);
                                              },
                                            );
                                          },
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
                                          onTap: () async {
                                            Navigator.pushReplacement(
                                                context, SignInScreen.route());
                                            await AuthService().signOut();
                                          },
                                        ),
                                      ),
                                    ]
                                  : [
                                      Expanded(
                                        child: CustomButton(
                                          width: double.infinity,
                                          height: 30,
                                          label: isFollowing
                                              ? 'Unfollow'
                                              : 'Follow',
                                          color: isFollowing
                                              ? accentGrey
                                              : accentBlue,
                                          textColor: isFollowing
                                              ? Colors.black
                                              : Colors.white,
                                          isLoading: false,
                                          onTap: () async {
                                            await FirestoreService().follow(
                                              auth.currentUser!.uid,
                                              uid,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: CustomButton(
                                          width: double.infinity,
                                          height: 30,
                                          label: 'Message',
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
            }
            return const Loader();
          },
        );
      },
    );
  }
}

class _EditProfile extends StatefulWidget {
  final user;

  const _EditProfile({
    super.key,
    required this.user,
  });

  @override
  State<_EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<_EditProfile> {
  Uint8List? _file;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  void _onUpdateProfile() async {
    await FirestoreService().updateProfile(
      context,
      _file!,
      _nameController.text,
      _usernameController.text,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        leadingWidth: 75,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _onUpdateProfile();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          14.0,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                Uint8List file = await pickImage(ImageSource.gallery);

                setState(() {
                  _file = file;
                });
              },
              child: ProfileImage(
                imageUrl: widget.user['imageUrl'],
                size: 50,
              ),
            ),
            TextField(
              controller: _nameController..text = widget.user['fullName'],
              decoration: const InputDecoration(
                hintText: 'Name',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _usernameController..text = widget.user['username'],
              decoration: const InputDecoration(
                hintText: 'Username',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
