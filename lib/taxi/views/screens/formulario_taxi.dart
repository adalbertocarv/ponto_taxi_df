import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ponto_taxi_df/taxi/controllers/mapa_controller.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../../services/endereco_osm_service.dart';
import '../widgets/formulario/pontos_salvos/pontos_salvos_secao.dart';
import '../widgets/formulario/secoes_formulario/formulario_secao.dart';
import '../widgets/formulario/botoes_acao/botoes_acao_secao.dart';

// -------------- IMPORT DO SQLITE --------------
import '../../data/app_database.dart';

class FormularioTaxi extends StatefulWidget {
  final List<Marker> pontos;
  const FormularioTaxi({super.key, required this.pontos});

  @override
  State<FormularioTaxi> createState() => _FormularioTaxiState();
}

class _FormularioTaxiState extends State<FormularioTaxi> {
  // DB -----------------------------------------------------------------------
  final _db = AppDatabase();      // singleton já trata abrir/fechar

  // Controllers --------------------------------------------------------------
  final _enderecoController    = TextEditingController();
  final _observacoesController = TextEditingController();
  final _vagasController       = TextEditingController();
  final _telefoneController    = TextEditingController();
  final _latitudeController    = TextEditingController();
  final _longitudeController   = TextEditingController();

  // Estados booleanos --------------------------------------------------------
  bool _pontoOficial   = false;
  bool _temSinalizacao = false;
  bool _temAbrigo      = false;
  bool _temEnergia     = false;
  bool _temAgua        = false;

  // Outros dados -------------------------------------------------------------
  String _classificacaoEstrutura = 'Estação';
  String _autorizatario          = '';
  String? _imagemPath;

  bool _isLoadingEndereco = true;
  final EnderecoService _enderecoService = EnderecoService();

  // -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _carregarEndereco();
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

  // ---------------- CAPTURA IMAGEM -----------------------------------------
  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    // copia a imagem para pasta Documents (para não ser apagada)
    final docsDir = await getApplicationDocumentsDirectory();
    final dst = File('${docsDir.path}/ponto_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await File(picked.path).copy(dst.path);

    setState(() => _imagemPath = dst.path);
  }

  // ---------------- SALVAR NO SQLITE ---------------------------------------
  Future<void> _salvar() async {
    // converte textos
    final firstMarker = widget.pontos.first;
    final lat = firstMarker.point.latitude;
    final lon = firstMarker.point.longitude;

    final vagas = int.tryParse(_vagasController.text) ?? 0;

    final ponto = Ponto(
      latitude              : lat,
      longitude             : lon,
      endereco              : _enderecoController.text,
      pontoOficial          : _pontoOficial,
      classificacaoEstrutura: _classificacaoEstrutura,
      numVagas              : vagas,
      temAbrigo             : _temAbrigo,
      temSinalizacao        : _temSinalizacao,
      temEnergia            : _temEnergia,
      temAgua               : _temAgua,
      observacoes           : _observacoesController.text,
      telefones             : [_telefoneController.text],
      imagens               : _imagemPath != null ? [_imagemPath!] : [],
    );


    final id = await _db.insertPonto(ponto);

    if (mounted) {
      final mapaController = context.read<MapaController>();
      mapaController.showSuccess('Ponto salvo com sucesso! 🎉');


      Future.delayed(const Duration(seconds: 2));
    }

  }

  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Formulário Táxi', style: TextStyle(fontWeight: FontWeight.bold),),
        //backgroundColor: themeProvider.primaryColor,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PontosSalvosSecao(pontos: widget.pontos),
              const SizedBox(height: 24),
              FormularioSection(
                // controllers
                enderecoController    : _enderecoController,
                observacoesController : _observacoesController,
                vagasController       : _vagasController,
                telefoneController    : _telefoneController,
                latitudeController    : _latitudeController,
                longitudeController   : _longitudeController,
                // valores
                pontoOficial          : _pontoOficial,
                temSinalizacao        : _temSinalizacao,
                temAbrigo             : _temAbrigo,
                temEnergia            : _temEnergia,
                temAgua               : _temAgua,
                classificacaoEstrutura: _classificacaoEstrutura,
                autorizatario         : _autorizatario,
                isLoadingEndereco     : _isLoadingEndereco,
                imagemSelecionada     : _imagemPath,
                // callbacks
                onPontoOficialChanged : (v) => setState(() => _pontoOficial   = v),
                onTemSinalizacaoChanged: (v) => setState(() => _temSinalizacao = v),
                onTemAbrigoChanged    : (v) => setState(() => _temAbrigo      = v),
                onTemEnergiaChanged   : (v) => setState(() => _temEnergia     = v),
                onTemAguaChanged      : (v) => setState(() => _temAgua        = v),
                onClassificacaoChanged: (v) => setState(() => _classificacaoEstrutura = v ?? ''),
                onAutorizatarioChanged: (v) => setState(() => _autorizatario  = v ?? ''),
                onImagemSelecionada   : _selecionarImagem,
              ),
              const SizedBox(height: 32),
              BotoesAcaoSecao(
                enderecoController   : _enderecoController,
                observacoesController: _observacoesController,
                onSalvar             : _salvar,
              ),
            ],
          ),
        ),
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
    super.dispose();
  }
}
