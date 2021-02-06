/*..............................................................................
 . Copyright (c)
 .
 . The firebase_media_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 06/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stash/flutter_stash.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/widgets/firebase/firebase_media_info.dart';
import 'package:video_player/video_player.dart';

class FirebaseMediaView extends StatelessWidget {
  final FirebaseFile firebaseFile;
  final AssetType type;

  const FirebaseMediaView({@required this.firebaseFile, @required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AssetType.image:
        return ImageScreen(firebaseFile);
      case AssetType.video:
      //return VideoScreen(file: futureFile);
      default:
        return Container(child: Center(child: Text("Can't display this type of file")));
    }
  }
}

class ImageScreen extends StatefulWidget {
  final FirebaseFile firebaseFile;

  const ImageScreen(this.firebaseFile);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  double lastVerticalDelta = 0;

  _updateVerticalDrag(DragUpdateDetails details) {
    lastVerticalDelta = details.primaryDelta;
  }

  _handleVerticalDrag() {
    if (lastVerticalDelta > -3.0) return;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => FirebaseMediaInfo(firebaseFile: widget.firebaseFile),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onDoubleTap: () => Navigator.of(context).pop(),
          onVerticalDragUpdate: (details) => _updateVerticalDrag(details),
          onVerticalDragEnd: (details) => _handleVerticalDrag(),
          //onHorizontalDragEnd: (details) => _handleHorizDrag(),
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: FutureWidget<File>(
              future: widget.firebaseFile.file,
              builder: (file) => Image.file(file),
            ),
          ),
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
