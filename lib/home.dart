import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manthan_video_card_app/widgets/video_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _cards = [];
  int _currentPlaying = 0;
  List<int> visibleIndexes = [];

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/dataset.json');
    final data = await json.decode(response);
    setState(() {
      _cards = data;
    });
  }

  void handleVisibilityChange(VisibilityInfo visibilityInfo, int index) {
    if (visibilityInfo.visibleFraction == 1) {
      visibleIndexes.add(index);
    } else {
      visibleIndexes.remove(index);
    }

    visibleIndexes.sort();

    setState(() {
      _currentPlaying = visibleIndexes[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 2, 132),
        title: const Text("Video Card App"),
      ),
      body: SafeArea(
        child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 28, 95, 161)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: itemBuilder,
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: true),
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: "Settings")
        ],
        backgroundColor: Colors.black,
        currentIndex: 0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return VisibilityDetector(
      key: ValueKey(_cards[index]["id"]),
      onVisibilityChanged: (visibilityInfo) =>
          handleVisibilityChange(visibilityInfo, index),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: VideoCard(
          id: _cards[index]["id"],
          title: _cards[index]["title"],
          videoUrl: _cards[index]["videoUrl"],
          coverPicture: _cards[index]["coverPicture"],
          isPlaying: _currentPlaying == index ? true : false,
        ),
      ),
    );
  }
}
