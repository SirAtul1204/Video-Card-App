import 'package:flutter/material.dart';
import 'package:manthan_video_card_app/home.dart';

void main() {
  runApp(const VideoCardApp());
}

class VideoCardApp extends StatelessWidget {
  const VideoCardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
