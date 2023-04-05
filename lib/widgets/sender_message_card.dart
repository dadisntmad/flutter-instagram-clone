import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final bool isSeen;

  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple.shade800,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(
              isSeen ? 'Seen' : '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
