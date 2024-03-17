import 'package:flutter/material.dart';

class MyStyles {
  static Color backgroundColor = Color(0xFF777777);

  static Color appBarColor = Color(0xFF8E44AD);

  // przyciski
  static ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF8E44AD)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(fontSize: 20.0),
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
    ),
  );

  // napisy
  static TextStyle backgroundTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 24.0,
  );

  // napisy na przyciskach
  static TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  );
}