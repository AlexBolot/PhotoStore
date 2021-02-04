/*..............................................................................
 . Copyright (c)
 .
 . The firebase_media_view.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 2/4/21 7:06 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_store/model/firebase_file.dart';
import 'package:photo_store/widgets/future_widget.dart';
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
    if (lastVerticalDelta < -3.0) {
      showMenu(context, widget.firebaseFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

showMenu(context, FirebaseFile firebaseFile) async {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setModalState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          padding: EdgeInsets.only(top: 8),
          child: Column(
            children: <Widget>[
              FutureWidget<List<String>>(
                future: firebaseFile.labels,
                builder: (labels) {
                  return Wrap(
                    spacing: 8,
                    children: labels.map((label) {
                      return Chip(
                        label: Text(label),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {
                          print('deleted $label');
                          firebaseFile.removeLabel(label);
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      });
    },
  );
}
