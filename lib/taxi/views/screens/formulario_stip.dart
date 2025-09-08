import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../widgets/formulario/pontos_salvos/pontos_salvos_secao.dart';
import '../widgets/formulario/secoes_formulario/formulario_secao.dart';
import '../widgets/formulario/botoes_acao/botoes_acao_secao.dart';

class FormularioSTIP extends StatefulWidget {

  final List<Marker> pontos;

  const FormularioSTIP({super.key, required this.pontos});

  @override
  State<FormularioSTIP> createState() => _FormularioSTIPState();
}

class _FormularioSTIPState extends State<FormularioSTIP> {
  final _enderecoController     = TextEditingController();
  final _observacoesController  = TextEditingController();
  final _vagasController        = TextEditingController();
  final _telefoneController     = TextEditingController();
  final _latitudeController     = TextEditingController();
  final _longitudeController    = TextEditingController();

  // final _db = AppDatabase();      // singleton já trata abrir/fechar

  bool   _pontoOficial          = false;
  bool   _temSinalizacao        = false;
  bool   _temAbrigo             = false;
  bool   _temEnergia            = false;
  bool   _temAgua               = false;

  String _classificacaoEstrutura= 'Edificado';
  String _autorizatario         = '';
  String? _imagemPath;

  bool _isLoadingEndereco       = true;

  @override
  void dispose() {
    _enderecoController.dispose();
    _observacoesController.dispose();
    _vagasController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }
  // ---------------- SALVAR NO SQLITE ---------------------------------------
  Future<void> _salvar() async {
    // converte textos
    final lat = double.tryParse(_latitudeController.text) ?? 0.0;
    final lon = double.tryParse(_longitudeController.text) ?? 0.0;
    final vagas = int.tryParse(_vagasController.text) ?? 0;

    // final ponto = Ponto(
    //   latitude              : lat,
    //   longitude             : lon,
    //   endereco              : _enderecoController.text,
    //   pontoOficial          : _pontoOficial,
    //   classificacaoEstrutura: _classificacaoEstrutura,
    //   numVagas              : vagas,
    //   temAbrigo             : _temAbrigo,
    //   temSinalizacao        : _temSinalizacao,
    //   temEnergia            : _temEnergia,
    //   temAgua               : _temAgua,
    //   observacoes           : _observacoesController.text,
    //   telefones             : [_telefoneController.text],
    //   imagens               : _imagemPath != null ? [_imagemPath!] : [],
    // );

    // final id = await _db.insertPonto(ponto);

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Ponto salvo com ID $id')),
    //   );
    //   Navigator.of(context).pop(); // ou limpar formulário, como preferir
    // }
  }

  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Formulário STIP',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PontosSalvosSecao(pontos: widget.pontos),
              const SizedBox(height: 24),
              FormularioSection(
                // controllers
                enderecoController     : _enderecoController,
                observacoesController  : _observacoesController,
                vagasController        : _vagasController,
                telefoneController     : _telefoneController,
                latitudeController     : _latitudeController,
                longitudeController    : _longitudeController,
                // valores
                pontoOficial           : _pontoOficial,
                temSinalizacao         : _temSinalizacao,
                temAbrigo              : _temAbrigo,
                temEnergia             : _temEnergia,
                temAgua                : _temAgua,
                classificacaoEstrutura : _classificacaoEstrutura,
                autorizatario          : _autorizatario,
                isLoadingEndereco      : _isLoadingEndereco,
                // callbacks
                onPontoOficialChanged  : (v) => setState(() => _pontoOficial = v),
                onTemSinalizacaoChanged: (v) => setState(() => _temSinalizacao = v),
                onTemAbrigoChanged     : (v) => setState(() => _temAbrigo = v),
                onTemEnergiaChanged    : (v) => setState(() => _temEnergia = v),
                onTemAguaChanged       : (v) => setState(() => _temAgua = v),
                onClassificacaoChanged : (v) => setState(() => _classificacaoEstrutura = v ?? ''),
                onAutorizatarioChanged : (v) => setState(() => _autorizatario = v ?? ''),
                onImagemSelecionada    : () {/* TODO: picker de imagem */}, imagemSelecionada: '',
              ),
              const SizedBox(height: 32),
              BotoesAcaoSecao(
                enderecoController: _enderecoController,
                observacoesController: _observacoesController,
                vagasController: _vagasController,
                onSalvar: _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
