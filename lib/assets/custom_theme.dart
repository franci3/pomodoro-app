import 'package:flutter/material.dart';

class PomodoroValues {

  static Color mainColor = const Color(0xffecefe4);
  static Color mainLight = const Color(0xff7b756b);
  static Color cardColor = const Color(0xff252426);
  static Color greenColor = const Color(0xff5a9e58);
  static Color redColor = const Color(0xfff44336);
  static Color orangeColor = const Color(0xffd78e20);

  static TextTheme customTextTheme = TextTheme(
    headline1: TextStyle(fontSize:36, color: mainColor, fontFamily: 'Lobster'),
    headline2: TextStyle(fontSize:36, color: mainColor),
    subtitle1: TextStyle(fontSize:26, color: mainColor),
    subtitle2: TextStyle(fontSize:24, color: mainColor),
    bodyText1: TextStyle(fontSize: 16, color: mainColor),
    bodyText2: TextStyle(fontSize: 14, color: mainColor),
    button: TextStyle(fontSize: 14, color: mainColor),
    caption: TextStyle(fontSize: 14, color: mainColor),
  );

  static ThemeData customTheme = ThemeData(
    fontFamily: 'Roboto',
    textTheme: customTextTheme,
    backgroundColor: mainColor,
    visualDensity: VisualDensity.adaptivePlatformDensity
  );
}
