/*..............................................................................
 . Copyright (c)
 .
 . The media_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/4/21 4:38 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class MediaView extends StatelessWidget {
  final Future<File> file;
  final AssetType type;

  const MediaView({@required this.file, @required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AssetType.image:
        return ImageScreen(file: file);
      case AssetType.video:
        return VideoScreen(file: file);
      default:
        return Container(child: Center(child: Text("Can't display this type of file")));
    }
  }

  Widget imageScreen() {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<File>(
        future: file,
        builder: (_, snapshot) {
          final file = snapshot.data;
          return (file != null) ? Image.file(file) : CircularProgressIndicator();
        },
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final Future<File> file;

  const ImageScreen({@required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<File>(
        future: file,
        builder: (_, snapshot) {
          final file = snapshot.data;
          return (file != null) ? Image.file(file) : CircularProgressIndicator();
        },
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final Future<File> file;

  const VideoScreen({@required this.file});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _controller;
  bool initialized = false;

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initVideo() async {
    final video = await widget.file;
    _controller = VideoPlayerController.file(video)
      // Play the video again when it ends
      ..setLooping(true)
      // initialize the controller and notify UI when done
      ..initialize().then((_) => setState(() => initialized = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialized
          // If the video is initialized, display it
          ? Scaffold(
              body: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                    }
                  });
                },
                // Display the correct icon depending on the state of the player.
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            )
          // If the video is not yet initialized, display a spinner
          : Center(child: CircularProgressIndicator()),
    );
  }
}
