import 'package:flutter/material.dart';
import '../../services/login_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  int? _usuarioId;
  int? get usuarioId => _usuarioId;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Faz login
  Future<bool> login(String nome, String matricula) async {
    final result = await LoginService.login(nome, matricula);

    if (result['success'] == true) {
      _usuarioId = result['idUsuario'];
      _isAuthenticated = true;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _isAuthenticated = false;
      _usuarioId = null;
      _errorMessage = result['error'];
      notifyListeners();
      return false;
    }
  }

  /// Faz logout
  Future<void> logout() async {
    await LoginService.logout();
    _isAuthenticated = false;
    _usuarioId = null;
    notifyListeners();
  }

  /// Verifica se já está logado (session persistente)
  Future<void> checkLoginStatus() async {
    final id = await LoginService.getUsuarioId();
    if (id != null) {
      _usuarioId = id;
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      _usuarioId = null;
    }
    notifyListeners();
  }
}
