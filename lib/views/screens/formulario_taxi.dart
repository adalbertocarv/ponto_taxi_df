import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
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
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  final TextEditingController _vagasController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _necessidadesController = TextEditingController();

  bool _pontoOficial = false;
  bool _temSinalizacao = false;
  String _classificacaoEstrutura = 'Coberto';
  String _autorizatario = '';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PontosSalvosSecao(pontos: widget.pontos),
              const SizedBox(height: 24),
              FormularioSection(
                enderecoController: _enderecoController,
                observacoesController: _observacoesController,
                vagasController: _vagasController,
                telefoneController: _telefoneController,
                necessidadesController: _necessidadesController,
                pontoOficial: _pontoOficial,
                temSinalizacao: _temSinalizacao,
                classificacaoEstrutura: _classificacaoEstrutura,
                autorizatario: _autorizatario,
                onPontoOficialChanged: (val) {
                  setState(() => _pontoOficial = val);
                },
                onTemSinalizacaoChanged: (val) {
                  setState(() => _temSinalizacao = val);
                },
                onClassificacaoChanged: (val) {
                  setState(() => _classificacaoEstrutura = val ?? '');
                },
                onAutorizatarioChanged: (val) {
                  setState(() => _autorizatario = val ?? '');
                },
                onImagemSelecionada: () {
                  // TODO: implementar picker de imagem
                },
              ),
              const SizedBox(height: 32),
              BotoesAcaoSecao(
                enderecoController: _enderecoController,
                observacoesController: _observacoesController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
