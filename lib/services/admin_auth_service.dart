import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AdminAuthService extends ChangeNotifier {
  static const defaultAdminEmail = 'admin@boutique-fluide.fr';
  static const _adminPasswordHash =
      'e3b4b9f1e5e4e3b2a1c3d4f5e6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5'; // placeholder
  static const _prefsKey = 'admin_logged_in';

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  AdminAuthService() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSignedIn = prefs.getBool(_prefsKey) ?? false;
      notifyListeners();
    } catch (_) {}
  }

  /// Returns null on success, or an error message string.
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network

    if (email.trim().toLowerCase() != defaultAdminEmail.toLowerCase()) {
      return 'Adresse e-mail inconnue.';
    }

    if (password != 'Admin123!') {
      return 'Mot de passe incorrect.';
    }

    _isSignedIn = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, true);
    } catch (_) {}

    return null;
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
    } catch (_) {}
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
