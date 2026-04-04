import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const _prefKey = 'app_theme';

  AppThemeType _currentTheme = AppThemeType.defaultTheme;

  AppThemeType get currentTheme => _currentTheme;

  ThemeProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null) {
      _currentTheme = AppThemeType.values.firstWhere(
        (t) => t.name == saved,
        orElse: () => AppThemeType.defaultTheme,
      );
    }
    AppColors.setTheme(_currentTheme);
    notifyListeners();
  }

  Future<void> setTheme(AppThemeType type) async {
    _currentTheme = type;
    AppColors.setTheme(type);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, type.name);
    notifyListeners();
  }
}
