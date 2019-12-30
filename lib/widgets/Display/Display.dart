import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final String content;
  final void Function({String content}) onTap;

  Display({Key key, this.content, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: GestureDetector(
        onTap: onTap,
        child: Tooltip(
          message: 'Tap to copy',
          child: Text(
            content,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}
