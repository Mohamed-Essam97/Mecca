import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../preference/preference.dart';

class AppLanguageModel extends ChangeNotifier {
  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale("en");

  fetchLocale() async {
    if (Preference.getString(PrefKeys.languageCode) == null) {
      _appLocale = Locale('en');
    } else {
      _appLocale = Locale(Preference.getString(PrefKeys.languageCode));
    }
    notifyListeners();

    return null;
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }

    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await Preference.setString(PrefKeys.languageCode, 'ar');
      await Preference.setString('countryCode', '');
    } else if (type == Locale("en")) {
      _appLocale = Locale("en");
      await Preference.setString(PrefKeys.languageCode, 'en');
    }else if (type == Locale("fr")) {
      _appLocale = Locale("fr");
      await Preference.setString(PrefKeys.languageCode, 'fr');
    }else if (type == Locale("fa")) {
      _appLocale = Locale("fa");
      await Preference.setString(PrefKeys.languageCode, 'fa');
    }else if (type == Locale("tr")) {
      _appLocale = Locale("tr");
      await Preference.setString(PrefKeys.languageCode, 'tr');
    }else if (type == Locale("hi")) {
      _appLocale = Locale("hi");
      await Preference.setString(PrefKeys.languageCode, 'hi');
    }else if (type == Locale("zh")) {
      _appLocale = Locale("zh");
      await Preference.setString(PrefKeys.languageCode, 'zh');
    }else if (type == Locale("ur")) {
      _appLocale = Locale("ur");
      await Preference.setString(PrefKeys.languageCode, 'ur');
    }else if (type == Locale("id")) {
      _appLocale = Locale("id");
      await Preference.setString(PrefKeys.languageCode, 'id');
    }else if (type == Locale("de")) {
      _appLocale = Locale("de");
      await Preference.setString(PrefKeys.languageCode, 'de');
    }
    notifyListeners();
  }
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString('assets/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String get(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr', 'fa', 'tr', 'hi', 'zh', 'ur', 'id', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
