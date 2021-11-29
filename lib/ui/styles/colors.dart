import 'dart:ui';

import 'package:Mecca/core/services/preference/preference.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryText = Color.fromARGB(255, 0, 0, 0);
  static const Color border = Color.fromARGB(255, 209, 209, 209);
  static const Color primary = Color.fromARGB(255, 49, 91, 77);
  static const Color primaryFont = Color.fromARGB(255, 41, 41, 41);
  static const Color secondary = Color.fromARGB(255, 236, 204, 82);
  static const Color accentElement = Color.fromARGB(255, 233, 233, 233);
  static const Color primaryText = Color.fromARGB(255, 28, 28, 28);
  static const Color facebook = Color.fromARGB(255, 66, 103, 178);
  static const Color gmail = Color.fromARGB(255, 219, 68, 55);
  static const Color accentText = Color.fromARGB(255, 255, 255, 255);

  static Color normalText = Colors.grey[700];
  static Color darkText = Colors.white70;

  static Color getDarkLightColor() {
    bool isDark = Preference.getBool(PrefKeys.isDark);
    return isDark ? darkText : normalText;
  }

  static Color getDarkLightBackGround() {
    bool isDark = Preference.getBool(PrefKeys.isDark);
    return isDark ? Color(0xff141D26) : Colors.grey[200];
  }

  static Color getDarkLightBackGround2() {
    bool isDark = Preference.getBool(PrefKeys.isDark);
    return isDark ? Color(0xff243447) : Colors.white;
  }

  static Color getDarkLightBackGroundTextField() {
    bool isDark = Preference.getBool(PrefKeys.isDark);
    return isDark ? Color(0xff141D26) : Colors.white;
  }

  static Color getDarkLightSecondaryBackGround() {
    bool isDark = Preference.getBool(PrefKeys.isDark);
    return isDark ? Color(0xff243447) : Colors.white;
  }
}
