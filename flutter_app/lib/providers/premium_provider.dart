import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumProvider extends ChangeNotifier {
  static const _prefKey = 'is_premium';
  static const maxFreeTrackers = 3;

  bool _isPremium = false;

  bool get isPremium => _isPremium;
  int get maxTrackers => _isPremium ? 999 : maxFreeTrackers;
  bool get canUseCustomThemes => _isPremium;
  bool get canUseAnimatedCursor => _isPremium;
  bool get canExportImage => _isPremium;

  PremiumProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_prefKey) ?? false;
    notifyListeners();
  }

  /// For testing / placeholder. Will be replaced by in-app purchase logic.
  Future<void> setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
    notifyListeners();
  }
}
