import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/chat_screen.dart';
import 'package:instagram/widgets/loader.dart';
import 'package:instagram/widgets/profile_image.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const MessagesScreen());

  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          user!.username,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            color: Colors.black,
            icon: const Icon(
              Icons.video_call_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            color: Colors.black,
            iconSize: 20,
            icon: const Icon(
              Icons.mode_edit_outlined,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('chats')
            .orderBy('timeSent', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final chat = snapshot.data!.docs[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: chat['chatId'],
                          profilePicture: chat['profilePicture'],
                          fullName: chat['fullName'],
                          username: chat['username'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  ProfileImage(
                                    imageUrl: chat['profilePicture'],
                                    size: 40,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(chat['username']),
                                        Text(
                                          chat['lastMessage'],
                                          style: TextStyle(
                                            color: auth.currentUser!.uid !=
                                                    chat['chatId']
                                                ? Colors.grey
                                                : Colors.black,
                                            fontWeight: auth.currentUser!.uid ==
                                                    chat['chatId']
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              color: Colors.grey,
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Loader();
        },
      ),
    );
  }
}
