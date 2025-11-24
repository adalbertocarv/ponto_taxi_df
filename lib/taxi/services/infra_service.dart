import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/infraestrutura.dart';

class InfraestruturaService {
  static const String _baseUrl = 'https://lathiest-gustily-carri.ngrok-free.dev';

  static Future<List<Infraestrutura>> buscarInfraestruturas() async {
    final response = await http.get(Uri.parse('$_baseUrl/infraestruturas/cadastradas'),
      headers: {
      'ngrok-skip-browser-warning': 'true',
    },);

    if (response.statusCode == 200) {
    final List<dynamic> list = json.decode(response.body);
    return list.map((e) => Infraestrutura.fromJson(e)).toList();
    } else {
    throw Exception('Falha ao buscar infraestruturas');
    }
  }
}
