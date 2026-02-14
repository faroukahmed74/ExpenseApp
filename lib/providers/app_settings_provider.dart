import 'package:flutter/material.dart';

import '../data/expense_repository.dart';

class AppSettingsProvider with ChangeNotifier {
  AppSettingsProvider(this._repo);

  final ExpenseRepository _repo;

  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  Locale? get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  bool get isArabic => _locale?.languageCode == 'ar';

  Future<void> load() async {
    final code = _repo.localeCode;
    _locale = code != null ? Locale(code) : null;
    switch (_repo.themeModeName) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale? value) async {
    _locale = value;
    await _repo.setLocaleCode(value?.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    final name = switch (value) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _repo.setThemeModeName(name);
    notifyListeners();
  }
}
