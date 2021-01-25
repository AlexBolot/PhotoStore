/*..............................................................................
 . Copyright (c)
 .
 . The future_widget.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/25/21 5:27 PM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';

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
        return CircularProgressIndicator();
      },
    );
  }
}
