// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AppLocalizations {
//   final Locale locale;
//
//   AppLocalizations(this.locale);
//
//   static AppLocalizations of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
//   }
//
//   late Map<String, String> _localizedStrings;
//
//   Future<bool> load() async {
//     String jsonString = await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//
//     _localizedStrings = jsonMap.map((key, value) {
//       return MapEntry(key, value.toString());
//     });
//
//     return true;
//   }
//
//   String translate(String key) {
//     return _localizedStrings[key] ?? key;
//   }
//
//
//
//   static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
// }
//
// class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'ar'].contains(locale.languageCode);
//   }
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     AppLocalizations localizations = AppLocalizations(locale);
//     await localizations.load();
//     return localizations;
//   }
//
//   @override
//   bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  late Map<String, dynamic> _localizedStrings;

  Future<bool> load() async {
    // Load the JSON file
    String jsonString = await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.json');
    _localizedStrings = json.decode(jsonString); // Keep the JSON as dynamic Map
    return true;
  }

  // Translate a key. Supports nested keys like "tabs.مركز ادارة الطلبات"
  dynamic translate(String key) {
    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;

    // Traverse the nested JSON
    for (var k in keys) {
      if (value[k] == null) return key; // Key not found
      value = value[k];
    }

    return value;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

   Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? localeCode = prefs.getString("selectedLanguage");
    if(localeCode == null){
      return  Locale("en");
    }else{
      return Locale(localeCode);
    }
  }
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
     const String _languageKey = "selectedLanguage";
    final savedLanguageCode = prefs.getString(_languageKey) ?? 'en';
    AppLocalizations localizations = AppLocalizations(Locale(savedLanguageCode));
  //  AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
