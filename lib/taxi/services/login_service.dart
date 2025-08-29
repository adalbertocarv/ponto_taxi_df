// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:ponto_taxi_df/taxi/services/url_backend_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String backend = CaminhoBackend.baseUrl;

  // Função para converter senha em MD5 e depois para hexadecimal
  static String _convertToMd5Hex(String password) {
    var bytes = utf8.encode(password);
    var digest = md5.convert(bytes);
    return digest.toString().toUpperCase();
  }

  static Future<Map<String, dynamic>> login(String username, String senha) async {
    final url = Uri.parse('${backend}8080/valida-md5/validar');

    try {
      // Converte a senha para MD5 em hexadecimal
      final senhaHasheada = _convertToMd5Hex(senha);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "senha": senhaHasheada,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        // Verifica se a resposta contém dados de sucesso
        if (json['mensagem'] == 'Acesso permitido') {
          final prefs = await SharedPreferences.getInstance();

          // Salva o id do usuário se disponível
          if (json['id_usuario'] != null) {
            await prefs.setInt('userId', json['id_usuario']);
          }

          if (json['username'] != null) {
            await prefs.setString('username', username);
          }

          return {'success': true, 'data': json};
        } else {
          return {'success': false, 'error': 'Credenciais inválidas'};
        }
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Credenciais inválidas'};
      }else if (response.statusCode == 403){
        return {'success': false, 'error': 'Acesso não permitido. \nEntre em contato com o Administrador'};
      }
      else {
        return {'success': false, 'error': 'Erro no servidor: ${response.statusCode}'};
      }
    } on TimeoutException {
      return {'success': false, 'error': 'Timeout'};
    } catch (e) {
      return {'success': false, 'error': 'Erro de conexão: Verifique sua conexão com a internet.'};
    }
  }

  static Future<int?> getUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? prefs.getInt('idUsuario');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('idUsuario');
    await prefs.remove('username');
  }

  // Função auxiliar para testar a conversão MD5 (remova em produção)
  static String testMd5Conversion(String password) {
    return _convertToMd5Hex(password);
  }
}