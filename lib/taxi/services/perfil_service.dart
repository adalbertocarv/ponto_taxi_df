import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url_backend_model.dart';
import '../models/usuario_model.dart';

class PerfilService {
  static const String backend = CaminhoBackend.baseUrl;

  Future<Usuario?> buscarInfoUsuario(String idUsuario) async {
    final url = Uri.parse('${backend}/funcionarios/$idUsuario');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      if (jsonList.isNotEmpty) {
        return Usuario.fromJson(jsonList.first);
      }
    }
    return null;
  }
}
