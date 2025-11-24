import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class PreCadastroStipService {
  static const String baseUrl = 'https://lathiest-gustily-carri.ngrok-free.dev/';
  final Dio _dio = Dio();

  PreCadastroStipService() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      validateStatus: (status) => status != null && status < 500,
    );

    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  }

  /// ============================================================
  ///  SALVAR PONTO STIP
  ///  Suporta Upload Mobile (arquivo) e Web (Uint8List)
  /// ============================================================
  Future<bool> salvarPontoStip({
    required int idUsuario,
    required double latitude,
    required double longitude,
    required String endereco,
    // required int idAutorizatario,
    required int idTipoInfraestrutura,
    required int numVagas,
    required bool sanitarios,
    required bool chuveiros,
    required bool vestiarios,
    required bool salaRepouso,
    required bool sinalInternet,
    required int codAvaliacao,
    required String descAvaliacao,
    // required bool paradaProxima,
    required String observacao,
    required bool pontoRecarga,
    required bool refeitorio,
    required bool bicicletario,
    required bool ambienteManutencao,
    required bool salaEspera,

    /// Imagem Mobile
    String? caminhoImagem,

    /// Imagem Web
    Uint8List? webImage,
  }) async {
    try {
      MultipartFile? imagem;

      // -----------------------------
      // 📌 Mobile (arquivo "File")
      // -----------------------------
      if (!kIsWeb && caminhoImagem != null && caminhoImagem.isNotEmpty) {
        imagem = await MultipartFile.fromFile(
          caminhoImagem,
          filename: caminhoImagem.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
      }

      // -----------------------------
      // 🌐 Web (Uint8List)
      // -----------------------------
      if (kIsWeb && webImage != null) {
        imagem = MultipartFile.fromBytes(
          webImage,
          filename: "web-upload.jpg",
          contentType: MediaType('image', 'jpeg'),
        );
      }

      final formData = FormData.fromMap({
        'id_usuario': idUsuario,
        'latitude': latitude,
        'longitude': longitude,
        'endereco': endereco,
        'id_tipo_infraestrutura': idTipoInfraestrutura,
        'num_vagas': numVagas,
        'Sanitarios': sanitarios,
        'Chuveiros': chuveiros,
        'Vestiarios': vestiarios,
        'SalaRepouso': salaRepouso,
        'SinalInternet': sinalInternet,
        'cod_avaliacao': codAvaliacao,
        'desc_avaliacao': descAvaliacao,
        // 'parada_proxima': paradaProxima,
        'observacao': observacao,
        'PontoRecarga': pontoRecarga,
        'Refeitorio': refeitorio,
        'Bicicletario': bicicletario,
        'AmbienteManutencao': ambienteManutencao,
        'SalaEspera': salaEspera,

        /// A imagem só é enviada se existir
        if (imagem != null) 'img_infraestrutura': imagem,
      });

      final Response response = await _dio.post(
        '/infraestrutura/stip',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      print("Erro ao enviar STIP. Status: ${response.statusCode}");
      print("Resposta: ${response.data}");
      return false;
    } on DioException catch (e) {
      print('=== ERRO DIO ===');
      print('Mensagem: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      print('Headers: ${e.response?.headers}');
      print('Body: ${e.response?.data}');
      return false;
    } catch (e, stack) {
      print('=== ERRO GENÉRICO ===');
      print('Erro: $e');
      print('Stack: $stack');
      return false;
    }
  }
}
