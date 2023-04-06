import 'package:chatgpt_app/screens/home_screen.dart';
import 'package:chatgpt_app/screens/speech_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const SpeechScreen(),
    );
  }
}
