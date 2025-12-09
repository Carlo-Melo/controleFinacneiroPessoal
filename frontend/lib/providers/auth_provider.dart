import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  String? token;
  bool loading = false;

  Future<void> login(String username, String password) async {
    loading = true;
    notifyListeners();
    token = await _service.login(username, password);
    await _storage.write(key: "token", value: token);
    loading = false;
    notifyListeners();
  }

  Future<void> register(String username, String password) async {
    loading = true;
    notifyListeners();
    await _service.register(username, password);
    loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    token = null;
    await _storage.delete(key: "token");
    notifyListeners();
  }

  Future<void> loadToken() async {
    token = await _storage.read(key: "token");
    notifyListeners();
  }

  bool get isAuthenticated => token != null;
}
