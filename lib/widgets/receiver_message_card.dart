import 'package:flutter/material.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/widgets/profile_image.dart';

class ReceiverMessageCard extends StatelessWidget {
  const ReceiverMessageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 250,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const ProfileImage(size: 20),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: accentGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'receiver message receiver message receiver message receiver message receiver message receiver message receiver message receiver message receiver message receiver message receiver message',
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
