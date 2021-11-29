import 'package:Mecca/core/services/preference/preference.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const headerStyle =
      TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
  static const subHeaderStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);

 static TextStyle normalText = TextStyle(color: Colors.black);
  static TextStyle darkText = TextStyle(color: Colors.white70);

  static TextStyle getNormalTextStyle() {
   bool isDark =   Preference.getBool(PrefKeys.isDark);
    return isDark ? darkText : normalText;
  }
}
