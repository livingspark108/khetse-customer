import 'package:flutter/material.dart';

class ColorConstants{

  static const Color veryLightBlue = Color(0xd4267b2);
  static const Color peach = Color(0xadc2e45);
  static const Color black = Colors.black12;

  static final Color Function(BuildContext) getForegroundColor = (BuildContext context) => MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

  static final Color Function(BuildContext) getBackgroundColor = (BuildContext context) => MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white;
}