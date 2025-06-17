import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/url_backend_model.dart';

class LoginService {
  static Future<Map<String, dynamic>> login(String nome, String matricula) async {
    final url = Uri.parse('${caminhoBackend.baseUrl}/usuarios/verificar');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": nome,
          "matricula": matricula,
        }),
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final idUsuario = json['idUsuario'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('idUsuario', idUsuario);

        return {'success': true, 'idUsuario': idUsuario};
      } else {
        return {'success': false, 'error': 'Credenciais inválidas'};
      }
    } on TimeoutException {
      return {'success': false, 'error': 'Timeout'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<int?> getUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUsuario');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('idUsuario');
  }
}
