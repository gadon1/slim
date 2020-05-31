import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Locale resource loader
abstract class SlimLocaleLoader {
  Locale _locale;

  /// Current OS locale
  Locale get locale => _locale;

  /// Load locales resources
  Future<bool> load();

  /// Translate locales resources
  String translate(String key) => key;
}

/// Localization configurations
class SlimLocalizations {
  /// Locales loader
  static SlimLocaleLoader slimLocaleLoader = _DefaultSlimLocaleLoader();

  /// Supported Locales
  static List<Locale> supportedLocales = [];

  /// Localizations delegates
  static List<LocalizationsDelegate> get delegates => [
        _SlimLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  SlimLocalizations(Locale locale) {
    slimLocaleLoader._locale = locale;
  }

  Future<bool> _load() => slimLocaleLoader.load();
}

class _DefaultSlimLocaleLoader extends SlimLocaleLoader {
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

class _SlimLocalizationsDelegate
    extends LocalizationsDelegate<SlimLocalizations> {
  @override
  bool isSupported(Locale locale) =>
      SlimLocalizations.supportedLocales.contains(locale);

  @override
  Future<SlimLocalizations> load(Locale locale) async {
    SlimLocalizations localizations = SlimLocalizations(locale);
    await localizations._load();
    return localizations;
  }

  @override
  bool shouldReload(_SlimLocalizationsDelegate old) => false;
}
