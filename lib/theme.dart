import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color lsPrimary = Color(0xFFFFC648);
const Color lsDark = Color(0xFF3F3B34);

final ThemeData locostallTheme = ThemeData(
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
    selectedColor: lsPrimary,
  ),
  radioTheme: const RadioThemeData(
    fillColor: MaterialStatePropertyAll(lsPrimary),
  ),
);
