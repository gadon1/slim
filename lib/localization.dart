import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class SlimLocaleLoader {
  Locale locale;
  Future<bool> load();
  String translate(String key);
}

class DefaultSlimLocaleLoader extends SlimLocaleLoader {
  Map<String, String> _localizedStrings;
  @override
  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/locales/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  @override
  String translate(String key) =>
      _localizedStrings[key] ?? "[${key.toUpperCase()}]";
}

class SlimLocalizations {
  static SlimLocaleLoader slimLocaleLoader = DefaultSlimLocaleLoader();

  static List<Locale> supportedLocales = [];

  static List<LocalizationsDelegate> delegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  SlimLocalizations(Locale locale) {
    slimLocaleLoader.locale = locale;
  }

  Future<bool> load() => slimLocaleLoader.load();

  static get delegate => SlimLocalizationsDelegate();
}

class SlimLocalizationsDelegate
    extends LocalizationsDelegate<SlimLocalizations> {
  @override
  bool isSupported(Locale locale) =>
      SlimLocalizations.supportedLocales.contains(locale);

  @override
  Future<SlimLocalizations> load(Locale locale) async {
    SlimLocalizations localizations = SlimLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(SlimLocalizationsDelegate old) => false;
}

extension SlimLocalizationX on BuildContext {
  String translate(String key) =>
      SlimLocalizations.slimLocaleLoader.translate(key);

  TextDirection get textDirection =>
      Localizations.of<WidgetsLocalizations>(this, WidgetsLocalizations)
          .textDirection;
}
