import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../../services/enderecoOSM_service.dart';
import '../widgets/formulario/pontos_salvos/pontos_salvos_secao.dart';
import '../widgets/formulario/secoes_formulario/formulario_section.dart';
import '../widgets/formulario/botoes_acao/botoes_acao_secao.dart';

class FormularioTaxi extends StatefulWidget {
  final List<Marker> pontos;

  const FormularioTaxi({super.key, required this.pontos});

  @override
  State<FormularioTaxi> createState() => _FormularioTaxiState();
}

class _FormularioTaxiState extends State<FormularioTaxi> {
  final _enderecoController     = TextEditingController();
  final _observacoesController  = TextEditingController();
  final _vagasController        = TextEditingController();
  final _telefoneController     = TextEditingController();
  final _necessidadesController = TextEditingController();

  bool   _pontoOficial          = false;
  bool   _temSinalizacao        = false;
  String _classificacaoEstrutura= 'Coberto';
  String _autorizatario         = '';

  bool _isLoadingEndereco       = true;

  final EnderecoService _enderecoService = EnderecoService();

  @override
  void initState() {
    super.initState();
    _carregarEndereco();
  }

  Future<void> _carregarEndereco() async {
    try {
      final endereco =
      await _enderecoService.obterEnderecoFormatado(widget.pontos);

      if (mounted) {
        setState(() {
          _enderecoController.text = endereco ?? '';
          _isLoadingEndereco = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar endereço: $e');
      if (mounted) {
        setState(() => _isLoadingEndereco = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível obter o endereço.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    _observacoesController.dispose();
    _vagasController.dispose();
    _telefoneController.dispose();
    _necessidadesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Formulário Táxi'),
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PontosSalvosSecao(pontos: widget.pontos),
              const SizedBox(height: 24),
              FormularioSection(
                // controllers
                enderecoController     : _enderecoController,
                observacoesController  : _observacoesController,
                vagasController        : _vagasController,
                telefoneController     : _telefoneController,
                // valores
                pontoOficial           : _pontoOficial,
                temSinalizacao         : _temSinalizacao,
                classificacaoEstrutura : _classificacaoEstrutura,
                autorizatario          : _autorizatario,
                isLoadingEndereco      : _isLoadingEndereco,
                // callbacks
                onPontoOficialChanged  : (v) => setState(() => _pontoOficial = v),
                onTemSinalizacaoChanged: (v) => setState(() => _temSinalizacao = v),
                onClassificacaoChanged : (v) => setState(() => _classificacaoEstrutura = v ?? ''),
                onAutorizatarioChanged : (v) => setState(() => _autorizatario = v ?? ''),
                onImagemSelecionada    : () {/* TODO: picker de imagem */},
              ),
              const SizedBox(height: 32),
              BotoesAcaoSecao(
                enderecoController   : _enderecoController,
                observacoesController: _observacoesController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
