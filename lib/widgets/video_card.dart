import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import "dart:math";

class VideoCard extends StatefulWidget {
  final int id;
  final String title;
  final String videoUrl;
  final String coverPicture;
  final bool isPlaying;
  const VideoCard(
      {Key? key,
      required this.id,
      required this.title,
      required this.videoUrl,
      required this.coverPicture,
      required this.isPlaying})
      : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _controller;
  int _likes = Random().nextInt(10);
  int _dislikes = Random().nextInt(10);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant VideoCard oldWidget) {
    if (widget.isPlaying) {
      _controller!.setVolume(0);
      _controller!.play();
    } else {
      _controller!.pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _controller!.value.isInitialized && widget.isPlaying
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : SizedBox(
                        width: 800,
                        height: 200,
                        child: Image(
                          image: NetworkImage(
                              "${widget.coverPicture}#${widget.id}"),
                          key: ValueKey(widget.id),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Image(
                            image: AssetImage("assets/logo.jpg"), width: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up),
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              _likes += 1;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 6),
                          child: Text("$_likes"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.thumb_down),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _dislikes += 1;
                            });
                          },
                        ),
                        Text("$_dislikes"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
