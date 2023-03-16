import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ProfileImage({
    Key? key,
    this.imageUrl,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl != ''
        ? SizedBox(
            width: size,
            height: size,
            child: CircleAvatar(
              backgroundImage: NetworkImage('$imageUrl'),
              radius: size,
            ),
          )
        : Image.asset(
            'assets/default.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
  }
}
