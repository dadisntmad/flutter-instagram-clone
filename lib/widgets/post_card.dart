import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/profile_image.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;

  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postedAt = DateFormat('d MMMM y').format(
      snap['datePublished'].toDate(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProfileImage(imageUrl: snap['profileImage'], size: 30),
                  const SizedBox(width: 10),
                  Text(
                    snap['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {},
          child: Image.network(
            snap['postUrl'],
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/comment.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/send.png',
                    width: 26,
                    height: 26,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.bookmark_border,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${snap['likes'].length} likes',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              if (snap['description'] != '')
                Row(
                  children: [
                    Text(
                      '${snap['username']} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        snap['description'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 4),
              const Text(
                'View all 3 comments',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                postedAt,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }
}
