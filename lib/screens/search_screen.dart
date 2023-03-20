import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/screens/post_detailed_screen.dart';
import 'package:instagram/screens/search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          onTap: () {
            setState(() {
              _isSearching = true;
            });
          },
          placeholder: 'Search',
        ),
        actions: [
          if (_isSearching)
            TextButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
        ],
      ),
      body: StreamBuilder(
        stream: db.collection('posts').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          return _isSearching
              ? SearchResultScreen(
                  searchText: _searchText,
                )
              : GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (_, int index) {
                    final post = snapshot.data!.docs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PostDetailedScreen(snap: post),
                          ),
                        );
                      },
                      child: Image.network(
                        post['postUrl'],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
