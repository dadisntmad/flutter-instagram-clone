import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/comment_screen.dart';
import 'package:instagram/services/firestore_service.dart';
import 'package:instagram/widgets/loader.dart';
import 'package:instagram/widgets/profile_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String postId;

  const PostCard({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentsCount = 0;

  void getComments() async {
    final commentSnap = await db
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .get();

    commentsCount = commentSnap.docs.length;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<UserProvider>().user;

    return StreamBuilder(
      stream: db.collection('posts').doc(widget.postId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot postSnap) {
        final snapshot = postSnap.data;

        if (postSnap.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

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
                      ProfileImage(
                        imageUrl: snapshot['profileImage'],
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        snapshot['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (user?.uid == snapshot['uid'])
                    IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                'Are you sure you want to delete post?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'OK');
                                    Navigator.of(context).pop();
                                    await FirestoreService().deletePost(
                                      snapshot['postId'],
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_horiz)),
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () async {
                await FirestoreService().likePost(
                  snapshot['postId'],
                  user!.uid,
                  snapshot['likes'],
                );
              },
              child: CachedNetworkImage(
                imageUrl: snapshot['postUrl'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirestoreService().likePost(
                          snapshot['postId'],
                          user!.uid,
                          snapshot['likes'],
                        );
                      },
                      icon: snapshot['likes'].contains(user?.uid)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              postId: widget.postId,
                              userPostId: snapshot['uid'],
                              userPicture: snapshot['profileImage'],
                            ),
                          ),
                        );
                      },
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
                    '${snapshot['likes'].length} ${snapshot['likes'].length == 1 ? 'like' : 'likes'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (snapshot['description'] != '')
                    Row(
                      children: [
                        Text(
                          '${snapshot['username']} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            snapshot['description'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  if (commentsCount > 0)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              postId: widget.postId,
                              userPostId: snapshot['uid'],
                              userPicture: snapshot['profileImage'],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'View all $commentsCount ${commentsCount == 1 ? 'comment' : 'comments'}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMMM y').format(
                      snapshot['datePublished'].toDate(),
                    ),
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
      },
    );
  }
}
