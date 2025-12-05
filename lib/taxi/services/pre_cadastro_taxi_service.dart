import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class PontoService {
  static const String baseUrl = 'https://lathiest-gustily-carri.ngrok-free.dev';
  final Dio _dio = Dio();

  PontoService() {
    // Configuração do Dio com timeouts maiores e logs
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      validateStatus: (status) => status != null && status < 500,
    );

    // Adiciona interceptor para debug (remova em produção)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<bool> salvarPonto({
    required int idUsuario,
    required double latitude,
    required double longitude,
    required String endereco,
    required int idAutorizatario,
    required int idGrupoInfraestrutura,
    required int idTipoInfraestrutura,
    required int numVagas,
    required bool pontoOficial,
    required bool sinalizacao,
    required bool abrigo,
    required bool energia,
    required bool agua,
    required int codAvaliacao,
    required String descAvaliacao,
    required String observacao,
    Uint8List? webImage,
    String? imagePath,
  }) async {
    try {

      FormData formData = FormData();

      // Adiciona campos com conversão adequada
      final fields = {
        'id_usuario': idUsuario.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'endereco': endereco.trim(),
        'id_grupo_infraestrutura': idGrupoInfraestrutura.toString(),
        'id_tipo_infraestrutura': idTipoInfraestrutura.toString(),
        'cod_avaliacao': codAvaliacao.toString(),
        'desc_avaliacao': descAvaliacao.trim(),
        'observacao': observacao.trim(),
        'id_autorizatario': idAutorizatario.toString(),
        'num_vagas': numVagas.toString(),
        'abrigo': abrigo.toString(),
        'sinalizacao': sinalizacao.toString(),
        'energia': energia.toString(),
        'agua': agua.toString(),
        'ponto_oficial': pontoOficial.toString(),
      };

      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      // Adiciona imagem se existir
      if (kIsWeb && webImage != null && webImage.isNotEmpty) {

        formData.files.add(
          MapEntry(
            'img_infraestrutura',
            MultipartFile.fromBytes(
              webImage,
              filename: 'ponto_${DateTime.now().millisecondsSinceEpoch}.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      } else if (!kIsWeb && imagePath != null && imagePath.isNotEmpty) {

        try {
          formData.files.add(
            MapEntry(
              'img_infraestrutura',
              await MultipartFile.fromFile(
                imagePath,
                filename: 'ponto_${DateTime.now().millisecondsSinceEpoch}.jpg',
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        } catch (e) {
          // Continua sem a imagem se houver erro
        }
      } else {
      }


      final response = await _dio.post(
        '/pre/cadastro/infraestrutura',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }

    } on DioException catch (e) {

      if (e.response != null) {
      }

      return false;
    } catch (e, stackTrace) {
      return false;
    }
  }
}