import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/services/firestore_service.dart';
import 'package:instagram/widgets/loader.dart';
import 'package:instagram/widgets/profile_image.dart';
import 'package:instagram/widgets/receiver_message_card.dart';
import 'package:instagram/widgets/sender_message_card.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String profilePicture;
  final String fullName;
  final String username;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.profilePicture,
    required this.fullName,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Row(
          children: [
            ProfileImage(imageUrl: profilePicture, size: 25),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            color: Colors.black,
            icon: const Icon(
              Icons.phone_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            color: Colors.black,
            icon: const Icon(
              Icons.video_call_outlined,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timeSent', descending: false)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final message = snapshot.data!.docs[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (auth.currentUser!.uid == message['senderId'])
                        SenderMessageCard(
                          message: message['text'],
                        ),
                      if (auth.currentUser!.uid == message['receiverId'])
                        ReceiverMessageCard(
                          message: message['text'],
                          imageUrl: message['senderImageUrl'],
                        ),
                    ],
                  ),
                );
              },
            );
          }
          return const Loader();
        },
      ),
      bottomNavigationBar: BottomTextField(
        receiverId: chatId,
      ),
    );
  }
}

class BottomTextField extends StatefulWidget {
  final String receiverId;
  const BottomTextField({Key? key, required this.receiverId}) : super(key: key);

  @override
  State<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends State<BottomTextField> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Message...',
                  filled: true,
                  fillColor: accentGrey,
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  FirestoreService().sendMessage(
                    text: _messageController.text,
                    receiverId: widget.receiverId,
                    sender: user!,
                  );
                  _messageController.clear();
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}