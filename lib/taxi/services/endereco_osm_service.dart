import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import '../models/endereco_osm_model.dart';

class EnderecoService {
  final http.Client _client;
  EnderecoService({http.Client? client}) : _client = client ?? http.Client();

  /// Consulta direto o Nominatim e devolve o modelo completo
  Future<EnderecoModel> buscarEndereco(double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude';

    final response = await _client
        .get(
      Uri.parse(url),
      headers: {'User-Agent': 'com.ponto.certo.taxi.ponto_certo_taxi'},
    )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return EnderecoModel.fromJson(data);
    }
    throw Exception('Erro ao buscar o endereço: ${response.statusCode}');
  }

  // recebe os marcadores, faz o reverse-geocoding
  // e devolve o endereço já formatado ou `null` se algo falhar.
  Future<String?> obterEnderecoFormatado(List<Marker> pontos) async {
    if (pontos.isEmpty) return null;

    final lat = pontos.first.point.latitude;
    final lon = pontos.first.point.longitude;

    final modelo = await buscarEndereco(lat, lon);
    return modelo.formattedAddress.isNotEmpty ? modelo.formattedAddress : null;
  }
}
