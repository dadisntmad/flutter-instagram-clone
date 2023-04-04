import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({Key? key}) : super(key: key);

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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'sender message sender message sender message sender message sender message sender message sender message sender message sender message sender message sender message',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Text(
              'Seen',
              style: TextStyle(
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
