import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ponto_taxi_df/taxi/controllers/mapa_controller.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../../services/endereco_osm_service.dart';
import '../../services/pre_cadastro.dart';
import '../widgets/formulario/pontos_salvos/pontos_salvos_secao.dart';
import '../widgets/formulario/secoes_formulario/formulario_secao.dart';
import '../widgets/formulario/botoes_acao/botoes_acao_secao.dart';

class FormularioTaxi extends StatefulWidget {
  final List<Marker> pontos;
  const FormularioTaxi({super.key, required this.pontos});

  @override
  State<FormularioTaxi> createState() => _FormularioTaxiState();
}

class _FormularioTaxiState extends State<FormularioTaxi> {
  // Serviços
  final PontoService _pontoService = PontoService();

  // Controllers
  final _enderecoController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _vagasController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _observacoesAvController = TextEditingController();

  // Estados booleanos
  bool _pontoOficial = false;
  bool _temSinalizacao = false;
  bool _temAbrigo = false;
  bool _temEnergia = false;
  bool _temAgua = false;

  // Outros dados
  String _classificacaoEstrutura = 'Edificado';
  String _autorizatario = '';
  String? _imagemPath;
  Uint8List? _webImage; // Para armazenar imagem da web
  double _notaAvaliacao = 1.0; // Valor do slider

  bool _isLoadingEndereco = true;
  bool _isSaving = false; // Estado de carregamento para salvamento
  final EnderecoService _enderecoService = EnderecoService();

  @override
  void initState() {
    super.initState();
    _carregarEndereco();
    _preencherCoordenadas();
  }

  Future<void> _carregarEndereco() async {
    final endereco = await _enderecoService.obterEnderecoFormatado(widget.pontos);
    if (mounted) {
      setState(() {
        _enderecoController.text = endereco ?? '';
        _isLoadingEndereco = false;
      });
    }
  }

  void _preencherCoordenadas() {
    if (widget.pontos.isNotEmpty) {
      final marker = widget.pontos.first;
      _latitudeController.text = marker.point.latitude.toString();
      _longitudeController.text = marker.point.longitude.toString();
    }
  }

  // Método para tratar imagem selecionada
  void _onImagemSelecionada(Uint8List? webImage, String? path) {
    setState(() {
      _webImage = webImage;
      _imagemPath = path;
    });
  }

  // Método para capturar imagem (mantido para compatibilidade)
  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final dst = File('${docsDir.path}/ponto_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await File(picked.path).copy(dst.path);

    setState(() => _imagemPath = dst.path);
  }

  // Método para mapear classificação para IDs
  int _getIdTipoInfraestrutura() {
    switch (_classificacaoEstrutura) {
      case 'Edificado':
        return 23;
      case 'Não Edificado':
        return 24;
      case 'Edificado Padrão Oscar Niemeyer':
        return 25;
      default:
        return 23;
    }
  }

  // Método principal de salvamento
  Future<void> _salvar() async {
    if (_isSaving) return; // Previne múltiplos envios

    // Validações básicas
    if (_enderecoController.text.trim().isEmpty) {
      _mostrarErro('Endereço é obrigatório');
      return;
    }

    if (_vagasController.text.trim().isEmpty) {
      _mostrarErro('Número de vagas é obrigatório');
      return;
    }

    if (_autorizatario.trim().isEmpty) {
      _mostrarErro('Autorizatário é obrigatório');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final marker = widget.pontos.first;

      // Extrai ID do autorizatário (assumindo formato "ID - Nome")
      int idAutorizatario = 45; // Valor padrão
      if (_autorizatario.contains(' - ')) {
        final parts = _autorizatario.split(' - ');
        idAutorizatario = int.tryParse(parts[0]) ?? 45;
      }

      final sucesso = await _pontoService.salvarPonto(
        idUsuario: 1, // Ajuste conforme sua lógica de usuário
        latitude: marker.point.latitude,
        longitude: marker.point.longitude,
        endereco: _enderecoController.text.trim(),
        idGrupoInfraestrutura: 2, // Conforme especificado na imagem
        idTipoInfraestrutura: _getIdTipoInfraestrutura(),
        codAvaliacao: _notaAvaliacao.toInt(),
        descAvaliacao: _observacoesAvController.text.trim().isEmpty
            ? 'Sem observações de avaliação'
            : _observacoesAvController.text.trim(),
        observacao: _observacoesController.text.trim().isEmpty
            ? 'Sem observações'
            : _observacoesController.text.trim(),
        idAutorizatario: idAutorizatario,
        paradaProxima: true, // Conforme especificado na imagem
        numVagas: int.tryParse(_vagasController.text.trim()) ?? 0,
        abrigo: _temAbrigo,
        sinalizacao: _temSinalizacao,
        energia: _temEnergia,
        agua: _temAgua,
        pontoOficial: _pontoOficial,
        webImage: _webImage,
        imagePath: _imagemPath,
      );

      if (mounted) {
        if (sucesso) {
          final mapaController = context.read<MapaController>();
          mapaController.showSuccess('Ponto salvo com sucesso! 🎉');

          // Aguarda um pouco e volta para a tela anterior
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          _mostrarErro('Erro ao salvar o ponto. Tente novamente.');
        }
      }
    } catch (e) {
      print('Erro ao salvar ponto: $e');
      if (mounted) {
        _mostrarErro('Erro inesperado ao salvar o ponto.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PontosSalvosSecao(pontos: widget.pontos),
          const SizedBox(height: 24),
          FormularioSection(
            // controllers
            enderecoController: _enderecoController,
            observacoesController: _observacoesController,
            observacoesAvController: _observacoesAvController,
            vagasController: _vagasController,
            telefoneController: _telefoneController,
            latitudeController: _latitudeController,
            longitudeController: _longitudeController,
            // valores
            pontoOficial: _pontoOficial,
            temSinalizacao: _temSinalizacao,
            temAbrigo: _temAbrigo,
            temEnergia: _temEnergia,
            temAgua: _temAgua,
            classificacaoEstrutura: _classificacaoEstrutura,
            autorizatario: _autorizatario,
            isLoadingEndereco: _isLoadingEndereco,
            imagemSelecionada: _imagemPath,
            valor: _notaAvaliacao,
            // callbacks
            onPontoOficialChanged: (v) => setState(() => _pontoOficial = v),
            onTemSinalizacaoChanged: (v) => setState(() => _temSinalizacao = v),
            onTemAbrigoChanged: (v) => setState(() => _temAbrigo = v),
            onTemEnergiaChanged: (v) => setState(() => _temEnergia = v),
            onTemAguaChanged: (v) => setState(() => _temAgua = v),
            onClassificacaoChanged: (v) => setState(() => _classificacaoEstrutura = v ?? ''),
            onAutorizatarioChanged: (v) => setState(() => _autorizatario = v ?? ''),
            onImagemSelecionada: _onImagemSelecionada,
            onNotaChanged: (v) => setState(() => _notaAvaliacao = v),
          ),
          const SizedBox(height: 32),
          BotoesAcaoSecao(
            enderecoController: _enderecoController,
            observacoesController: _observacoesController,
            vagasController: _vagasController,
            onSalvar: _salvar,
            isLoading: _isSaving, // Passa o estado de carregamento
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildBackButton(context),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        PontosSalvosSecao(pontos: widget.pontos),
                        const SizedBox(height: 24),
                        _buildCoordenadasCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        FormularioSection(
                          // controllers
                          enderecoController: _enderecoController,
                          observacoesController: _observacoesController,
                          observacoesAvController: _observacoesAvController,
                          vagasController: _vagasController,
                          telefoneController: _telefoneController,
                          latitudeController: _latitudeController,
                          longitudeController: _longitudeController,
                          // valores
                          pontoOficial: _pontoOficial,
                          temSinalizacao: _temSinalizacao,
                          temAbrigo: _temAbrigo,
                          temEnergia: _temEnergia,
                          temAgua: _temAgua,
                          classificacaoEstrutura: _classificacaoEstrutura,
                          autorizatario: _autorizatario,
                          isLoadingEndereco: _isLoadingEndereco,
                          imagemSelecionada: _imagemPath,
                          valor: _notaAvaliacao,
                          // callbacks
                          onPontoOficialChanged: (v) => setState(() => _pontoOficial = v),
                          onTemSinalizacaoChanged: (v) => setState(() => _temSinalizacao = v),
                          onTemAbrigoChanged: (v) => setState(() => _temAbrigo = v),
                          onTemEnergiaChanged: (v) => setState(() => _temEnergia = v),
                          onTemAguaChanged: (v) => setState(() => _temAgua = v),
                          onClassificacaoChanged: (v) => setState(() => _classificacaoEstrutura = v ?? ''),
                          onAutorizatarioChanged: (v) => setState(() => _autorizatario = v ?? ''),
                          onImagemSelecionada: _onImagemSelecionada,
                          onNotaChanged: (v) => setState(() => _notaAvaliacao = v),
                        ),
                        const SizedBox(height: 32),
                        BotoesAcaoSecao(
                          enderecoController: _enderecoController,
                          observacoesController: _observacoesController,
                          vagasController: _vagasController,
                          onSalvar: _salvar,
                          isLoading: _isSaving,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoordenadasCard() {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final marker = widget.pontos.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF4A90E2),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Coordenadas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildCoordenadasItem(
                  'Latitude',
                  marker.point.latitude.toStringAsFixed(6),
                  Icons.horizontal_rule,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCoordenadasItem(
                  'Longitude',
                  marker.point.longitude.toStringAsFixed(6),
                  Icons.vertical_align_center,
                  themeProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordenadasItem(
      String label,
      String value,
      IconData icon,
      ThemeProvider themeProvider,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Colors.grey.shade700
              : const Color(0xFFE9ECEF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeProvider.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      appBar: !_isDesktop(context)
          ? AppBar(
        title: const Column(
          children: [
            Text(
              'Formulário Táxi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        elevation: _isDesktop(context) ? 0 : null,
        centerTitle: !_isDesktop(context),
      )
          : null,
      body: SafeArea(
        child: _isDesktop(context)
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    _observacoesController.dispose();
    _vagasController.dispose();
    _telefoneController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _observacoesAvController.dispose();
    super.dispose();
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
    );
  }
}