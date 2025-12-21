import 'package:app_alfardos/core/wedgit/wedgit_app/coloers.dart';
import 'package:flutter/material.dart';


class AppThemLightMode {
  static ThemeData lightTheme = ThemeData(

      scaffoldBackgroundColor: MyColorsApp.mainColor,

      textTheme: lightTextThem,
      fontFamily: 'Cairo',

      appBarTheme: AppBarTheme(backgroundColor: MyColorsApp.AppBarColor),

      inputDecorationTheme: InputDecorationTheme(
        fillColor:  Colors.white.withAlpha(1),
        filled: true,
        hintStyle: TextStyle(color:Colors.white, fontSize: 10),

        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white30)
        ),

        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:Colors.white30)
        ),
      ),
  );
}

TextTheme lightTextThem = TextTheme(
  displayLarge: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    color: Color(0xff2F2F2F),
  ),
  displayMedium: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: Color(0xff2F2F2F),
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Color(0xff8391A1),
  ),
);
