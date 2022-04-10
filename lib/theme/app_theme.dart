import 'package:flutter/material.dart';

Color primaryBlue = const Color(0xff2972ff);
Color textBlack = const Color(0xff222222);
Color textGrey = const Color(0xff94959b);
Color textWhiteGrey = const Color(0xfff1f1f5);

TextStyle heading2 = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

TextStyle heading5 = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle heading6 = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle regular16pt = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Rubik',
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(),
        textTheme: const TextTheme());
  }
}
