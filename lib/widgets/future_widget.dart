/*..............................................................................
 . Copyright (c)
 .
 . The future_widget.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 8:01 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

typedef BuilderFunction<T> = Widget Function(T data);

class FutureWidget<T> extends StatelessWidget {
  final Future future;
  final BuilderFunction<T> builder;
  final T initialData;

  const FutureWidget({this.future, this.builder, this.initialData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(snapshot.data);
        }
        return Loader();
      },
    );
  }
}

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
      child: LiquidCircularProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.white,
        borderColor: Colors.blue,
        borderWidth: 5.0,
        direction: Axis.vertical,
        center: Text('Chargement...', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}