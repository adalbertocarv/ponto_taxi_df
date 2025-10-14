import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PontoService {
  static const String baseUrl = 'http://10.233.144.111:3000';
  final Dio _dio = Dio();

  Future<bool> salvarPonto({
    required int idUsuario,
    required double latitude,
    required double longitude,
    required String endereco,
    required int idGrupoInfraestrutura,
    required int idTipoInfraestrutura,
    required int codAvaliacao,
    required String descAvaliacao,
    required String observacao,
    required int idAutorizatario,
    required bool paradaProxima,
    required int numVagas,
    required bool abrigo,
    required bool sinalizacao,
    required bool energia,
    required bool agua,
    required bool pontoOficial,
    Uint8List? webImage,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData();

      // Adiciona todos os campos obrigatórios
      formData.fields.addAll([
        MapEntry('id_usuario', idUsuario.toString()),
        MapEntry('latitude', latitude.toString()),
        MapEntry('longitude', longitude.toString()),
        MapEntry('endereco', endereco),
        MapEntry('id_grupo_infraestrutura', idGrupoInfraestrutura.toString()),
        MapEntry('id_tipo_infraestrutura', idTipoInfraestrutura.toString()),
        MapEntry('cod_avaliacao', codAvaliacao.toString()),
        MapEntry('desc_avaliacao', descAvaliacao),
        MapEntry('observacao', observacao),
        MapEntry('id_autorizatario', idAutorizatario.toString()),
        MapEntry('parada_proxima', paradaProxima ? 'true' : 'false'),
        MapEntry('num_vagas', numVagas.toString()),
        MapEntry('abrigo', abrigo ? 'true' : 'false'),
        MapEntry('sinalizacao', sinalizacao ? 'true' : 'false'),
        MapEntry('energia', energia ? 'true' : 'false'),
        MapEntry('agua', agua ? 'true' : 'false'),
        MapEntry('ponto_oficial', pontoOficial ? 'true' : 'false'),
      ]);

      // Adiciona a imagem se existir
      if (kIsWeb && webImage != null) {
        formData.files.add(
          MapEntry(
            'img_infraestrutura',
            MultipartFile.fromBytes(
              webImage,
              filename: 'ponto_${DateTime.now().millisecondsSinceEpoch}.jpg',
              contentType: DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      } else if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'img_infraestrutura',
            await MultipartFile.fromFile(
              imagePath,
              filename: 'ponto_${DateTime.now().millisecondsSinceEpoch}.jpg',
              contentType: DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await _dio.post(
        '$baseUrl/pre/cadastro/infraestrutura',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao salvar ponto: $e');
      return false;
    }
  }
}