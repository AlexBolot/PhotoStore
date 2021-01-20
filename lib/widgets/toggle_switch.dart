/*..............................................................................
 . Copyright (c)
 .
 . The toggle_switch.dart class was created by : Alex Bolot and Pierre Bolot
 .
 . As part of the PhotoStore project
 .
 . Last modified : 1/20/21 1:01 AM
 .
 . Contact : contact.alexandre.bolot@gmail.com
 .............................................................................*/

import 'package:flutter/material.dart';

const double bubbleSize = 25;
const double textSize = 70;
const double padding = 5;
const double totalWidth = bubbleSize + textSize + padding * 2;

class ToggleSwitch extends StatefulWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const ToggleSwitch({
    this.isActive,
    this.onChanged,
    this.activeColor,
    this.inactiveColor = Colors.grey,
    this.activeText = 'On',
    this.inactiveText = 'Off',
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
  });

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _circleAnimation = AlignmentTween(
            begin: widget.isActive ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.isActive ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

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
            widget.onChanged(!widget.isActive);
          },
          child: Container(
            height: 30.0,
            width: totalWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: widget.isActive ? widget.activeColor : widget.inactiveColor),
            padding: const EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ToggleSwitchText(
                  display: widget.isActive,
                  text: widget.activeText,
                  color: widget.activeTextColor,
                ),
                ToggleSwitchBubble(alignment: _circleAnimation.value),
                ToggleSwitchText(
                  display: !widget.isActive,
                  text: widget.inactiveText,
                  color: widget.inactiveTextColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ToggleSwitchText extends StatelessWidget {
  final display;
  final text;
  final color;

  const ToggleSwitchText({
    this.display,
    this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!display) return Container();

    return Container(
      width: textSize,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class ToggleSwitchBubble extends StatelessWidget {
  final AlignmentGeometry alignment;

  const ToggleSwitchBubble({this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
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
