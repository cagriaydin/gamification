import 'package:flutter/material.dart';

const darkPrimary = Color(0xff263964);
const lightPrimary = Color(0xffC7CAD1);
const secondaryLight = Color(0xffFFFFFF);
const secondaryDark = Color(0xff26315F);
const onPrimary = Color(0xff30E3CA);
const title = Color(0xff26315F);
const subTitle = Color(0xff393E45);
const darkCard = Color(0xff4F546B);

ThemeData customTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: lightPrimary,
  appBarTheme: AppBarTheme(
    color: darkPrimary,
  ),
  primaryColorDark: darkPrimary,
  accentColor: secondaryDark,
  primaryColor: lightPrimary,
  primaryColorLight: secondaryLight,
  cardColor: darkCard,
  highlightColor: onPrimary,
  iconTheme: IconThemeData(color: secondaryLight),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: onPrimary),
  primaryIconTheme: IconThemeData.fallback().copyWith(color: secondaryLight),
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: lightPrimary,
    primaryColorDark: darkPrimary,
    accentColor: secondaryDark,
    cardColor: lightPrimary,
    errorColor: secondaryLight,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
        title: ThemeData.light().textTheme.title.copyWith(
              color: title,
              fontSize: 24.0,
              fontWeight: FontWeight.bold
            ),
        subhead: ThemeData.light().textTheme.subhead.copyWith(
              color: subTitle,
            ),
      ),
);
/**/
