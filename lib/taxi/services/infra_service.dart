import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/infraestrutura.dart';

class InfraestruturaService {
  static const String _baseUrl = 'http://10.233.144.11:3000';

  static Future<List<Infraestrutura>> buscarInfraestruturas() async {
    final response = await http.get(Uri.parse('$_baseUrl/infraestruturas/cadastradas'));

    if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);
    return list.map((e) => Infraestrutura.fromJson(e)).toList();
    } else {
    throw Exception('Falha ao buscar infraestruturas');
    }
  }
}
