import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import '../services/ws_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final WsService _ws = WsService();

  bool _isLoading = true;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _api.onAuthExpired = _onAuthExpired;
    tryRestoreSession();
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  Future<void> login(String email, String password) async {
    await _api.login(email, password);
    _isAuthenticated = true;
    _ws.connect();
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    await _api.register(email, password);
    _isAuthenticated = true;
    _ws.connect();
    notifyListeners();
  }

  Future<void> logout() async {
    _ws.disconnect();
    try {
      await _api.logout();
    } finally {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> tryRestoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final restored = await _api.tryRestoreSession();
      _isAuthenticated = restored;
      if (restored) {
        _ws.connect();
      }
    } catch (e) {
      debugPrint('AuthProvider: restore session failed: $e');
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _onAuthExpired() {
    _ws.disconnect();
    _isAuthenticated = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _api.onAuthExpired = null;
    _ws.disconnect();
    super.dispose();
  }
}
