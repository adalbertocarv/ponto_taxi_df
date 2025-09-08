import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/autorizatario.dart';

class AutorizatarioService {
  static Future<List<Autorizatario>> buscarAutorizatarios(String numero) async {
    if (numero.isEmpty) return [];

    final url = Uri.parse('http://10.233.144.111:3000/autorizatarios/$numero');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Autorizatario.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar autorizatários');
    }
  }
}