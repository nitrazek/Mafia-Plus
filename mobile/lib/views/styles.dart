import 'package:flutter/material.dart';

class MyStyles {
  static Color backgroundColor = Color(0xFF212121);

  static Color appBarColor = Color(0xFF8E44AD);

  static Color lightPurple = Color(0xA569BD);

  static Color green = Color(0x80DB80);
  static Color red = Color(0xB22222);

  // style dla inputów
  static InputDecoration inputStyle = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    hintText: 'Enter text',
    hintStyle: TextStyle(color: Colors.grey),
  );

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
    elevation: MaterialStateProperty.all<double>(5.0), // Dodanie cienia
    shadowColor: MaterialStateProperty.all<Color>(Colors.grey), // Kolor cienia
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


  // napisy na inputach
  static TextStyle inputTextStyle = TextStyle(
    color: backgroundColor,
    fontSize: 16.0,
  );
}