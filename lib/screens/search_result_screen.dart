import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/widgets/profile_image.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchText;

  const SearchResultScreen({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: db
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: searchText)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final user = snapshot.data!.docs[index];

              if (searchText.isEmpty) {
                return const SizedBox.shrink();
              }

              if (user['username']
                  .toString()
                  .startsWith(searchText.toLowerCase())) {
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
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
                            ProfileImage(imageUrl: user['imageUrl'], size: 35),
                            const SizedBox(width: 10),
                            user['fullName'] != ''
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['username'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${user['fullName']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    user['username'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
