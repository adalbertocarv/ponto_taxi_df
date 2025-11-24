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
      print('=== INICIANDO ENVIO ===');
      print('URL: $baseUrl/pre/cadastro/infraestrutura');

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

      print('=== CAMPOS DO FORMULÁRIO ===');
      fields.forEach((key, value) {
        print('$key: $value');
        formData.fields.add(MapEntry(key, value));
      });

      // Adiciona imagem se existir
      if (kIsWeb && webImage != null && webImage.isNotEmpty) {
        print('=== ADICIONANDO IMAGEM WEB ===');
        print('Tamanho: ${webImage.length} bytes');

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
        print('=== ADICIONANDO IMAGEM MOBILE ===');
        print('Path: $imagePath');

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
          print('Erro ao adicionar imagem do arquivo: $e');
          // Continua sem a imagem se houver erro
        }
      } else {
        print('=== NENHUMA IMAGEM FORNECIDA ===');
      }

      print('=== ENVIANDO REQUISIÇÃO ===');

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

      print('=== RESPOSTA RECEBIDA ===');
      print('Status: ${response.statusCode}');
      print('Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ PONTO SALVO COM SUCESSO');
        return true;
      } else {
        print('❌ ERRO: Status ${response.statusCode}');
        print('Resposta: ${response.data}');
        return false;
      }

    } on DioException catch (e) {
      print('=== ERRO DIO ===');
      print('Tipo: ${e.type}');
      print('Mensagem: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');

      if (e.response != null) {
        print('Headers: ${e.response?.headers}');
      }

      return false;
    } catch (e, stackTrace) {
      print('=== ERRO GENÉRICO ===');
      print('Erro: $e');
      print('Stack: $stackTrace');
      return false;
    }
  }
}