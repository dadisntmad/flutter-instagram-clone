import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const MainScreen());

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
