import 'package:cached_network_image/cached_network_image.dart';
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
            child: CachedNetworkImage(
              imageUrl: imageUrl.toString(),
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: size,
                backgroundImage: imageProvider,
              ),
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
