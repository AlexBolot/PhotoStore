/*..............................................................................
 . Copyright (c)
 .
 . The toggle_switch.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 15/02/2021
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double bubbleSize = 25;
const double textSize = 70;
const double padding = 5;
const double totalWidth = bubbleSize + textSize + padding * 2;

class ToggleSwitchItem<T> {
  Color color;
  Color textColor;
  T value;
  String text;

  ToggleSwitchItem({this.textColor, this.color, this.value, this.text});
}

class ToggleSwitch<T> extends StatefulWidget {
  final bool isActive;
  final ValueChanged<T> onChanged;
  final ToggleSwitchItem<T> activeItem;
  final ToggleSwitchItem<T> inactiveItem;

  ToggleSwitch({
    @required this.isActive,
    @required this.onChanged,
    @required this.activeItem,
    @required this.inactiveItem,
  }) {
    assert(activeItem != null);
    assert(inactiveItem != null);

    this.activeItem.color ??= Colors.blueAccent;
    this.activeItem.textColor ??= Colors.white;
    this.activeItem.text ??= 'On';

    this.inactiveItem.color ??= Colors.grey;
    this.inactiveItem.textColor ??= Colors.white;
    this.activeItem.text ??= 'Off';
  }

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState<T> extends State<ToggleSwitch<T>> with SingleTickerProviderStateMixin {
  Animation<Offset> _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    const left = const Offset(0, 0.0);
    const right = const Offset(2.9, 0.0);

    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _circleAnimation = Tween<Offset>(
      begin: widget.isActive ? right : left,
      end: widget.isActive ? left : right,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  T getOtherValue() => widget.isActive ? widget.inactiveItem.value : widget.activeItem.value;

  ToggleSwitchItem<T> get item => widget.isActive ? widget.activeItem : widget.inactiveItem;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }

            widget.onChanged(getOtherValue());
          },
          child: Container(
            height: 30.0,
            width: totalWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.isActive ? widget.activeItem.color : widget.inactiveItem.color,
            ),
            padding: const EdgeInsets.all(padding),
            child: Stack(
              children: <Widget>[
                ToggleSwitchText(
                  text: item.text,
                  color: item.textColor,
                  alignment: widget.isActive ? Alignment.centerLeft : Alignment.centerRight,
                ),
                ToggleSwitchBubble(animation: _circleAnimation),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ToggleSwitchText extends StatelessWidget {
  final text;
  final color;
  final alignment;

  const ToggleSwitchText({this.text, this.color, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: totalWidth,
      child: Align(
        alignment: alignment,
        child: Container(
          width: textSize,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleSwitchBubble extends StatelessWidget {
  final Animation<Offset> animation;

  const ToggleSwitchBubble({Key key, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        width: bubbleSize,
        height: bubbleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
