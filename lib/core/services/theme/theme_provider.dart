import 'package:Mecca/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:Mecca/core/services/preference/preference.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark;
  ThemeProvider() {
    // Preference.setBool(PrefKeys.isDark, false);

    isDark = Preference.getBool(PrefKeys.isDark) ?? false;
  }

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    // primaryColor: Color.fromARGB(255, 255, 255, 255),
    textTheme: TextTheme()
        .apply(bodyColor: Colors.white70, displayColor: Colors.white70),
    iconTheme: IconThemeData(color: Colors.white70),
    cardColor: Colors.blue,
    buttonTheme: ButtonThemeData(buttonColor: Color(0xffab351c)),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white70,
      unselectedLabelColor: Colors.white30,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
      // labelColor: Colors.black,
      // indicatorColor: AppColors.primary,
      // labelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    scaffoldBackgroundColor: Color(0xff141D26),
    accentColor: Colors.white70,
    cardTheme: CardTheme(color: Color(0xff141D26)),

    backgroundColor: Color(0xff141D26),
    primaryTextTheme: TextTheme()
        .apply(bodyColor: Colors.white70, displayColor: Colors.white70),
  );

  ThemeData light = ThemeData(
    brightness: Brightness.light,

    primaryColor: Colors.blueAccent,
    // textTheme: TextTheme(body1: TextStyle(color: Colors.white).apply()),
    textTheme:
        TextTheme().apply(bodyColor: Colors.black, displayColor: Colors.orange),

    iconTheme: IconThemeData(color: Colors.black),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.blueAccent,

    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
      // labelColor: Colors.black,
      // indicatorColor: AppColors.primary,
      // labelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontFamily: "TeXGyreAdventor-Regular",
        fontSize: 11.181839942932129,
        color: Color(0xff939598),
      ),
      hintStyle: TextStyle(
        fontFamily: "NeusaNextW00-Regular",
        fontSize: 10.358949661254883,
        color: Color(0xff758091),
      ),
    ),
  );

  get switchTheme {
    isDark = !isDark;
    Preference.setBool(PrefKeys.isDark, isDark);

    notifyListeners();
  }
}
