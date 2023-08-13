import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color lsPrimary = Color(0xFFFFC648);
const Color lsDarkerPrimary = Color(0xFFFFA000);
const Color lsDark = Color(0xFF3F3B34);

final ThemeData locostallTheme = ThemeData(
  primarySwatch: Colors.amber,
  primaryColor: lsPrimary,
  appBarTheme: const AppBarTheme(
    backgroundColor: lsPrimary,
    foregroundColor: lsDark,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'BowlbyOneSC',
      fontSize: 20,
      color: lsDark,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: lsDark,
    backgroundColor: lsPrimary,
  ),
  listTileTheme: const ListTileThemeData(
    selectedColor: lsDarkerPrimary,
  ),
  radioTheme: const RadioThemeData(
    fillColor: MaterialStatePropertyAll(lsPrimary),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.white,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: lsDark,
    selectionColor: Colors.amber.shade200,
    selectionHandleColor: lsPrimary,
  ),
);
