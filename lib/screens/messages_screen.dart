import 'package:flutter/material.dart';
import 'package:instagram/widgets/profile_image.dart';

class MessagesScreen extends StatelessWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const MessagesScreen());

  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'username',
          style: TextStyle(
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
      body: ListView.builder(
        itemCount: 25,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const ProfileImage(size: 40),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('full name'),
                                  Text(
                                    'last message last message last message last message last messagelast messagelast messagelast messagelast message',
                                    style: TextStyle(
                                      color: Colors.grey,
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
      ),
    );
  }
}
