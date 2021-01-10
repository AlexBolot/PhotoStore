/*..............................................................................
 . Copyright (c)
 .
 . The media_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/10/21 5:22 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/services/firebase_service.dart';
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
}

class ImageScreen extends StatelessWidget {
  final Future<File> file;

  const ImageScreen({@required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: FutureBuilder<File>(
                future: file,
                builder: (_, snapshot) {
                  final file = snapshot.data;
                  return (file != null) ? Image.file(file) : CircularProgressIndicator();
                },
              ),
            ),
            RaisedButton.icon(
              label: Text('upload'),
              icon: Icon(Icons.cloud_upload_outlined),
              onPressed: () async => FirebaseService.saveImage(await file),
            )
          ],
        ),
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

  @override
  void initState() {
    _initController();
    super.initState();
  }

  _initController() async {
    _controller = VideoPlayerController.file(await widget.file);

    _controller.addListener(() => setState(() {}));
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                Stack(
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 50),
                      reverseDuration: Duration(milliseconds: 200),
                      child: _controller.value.isPlaying
                          ? SizedBox.shrink()
                          : Container(
                              color: Colors.black26,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 80.0,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () => _controller.value.isPlaying ? _controller.pause() : _controller.play(),
                    ),
                  ],
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(playedColor: Colors.blueAccent),
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
