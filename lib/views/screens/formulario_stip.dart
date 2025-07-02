import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/formulario/pontos_salvos/pontos_salvos_secao.dart';
import '../widgets/formulario/secoes_formulario/formulario_section.dart';
import '../widgets/formulario/botoes_acao/botoes_acao_secao.dart';

class FormularioStip extends StatefulWidget {
  final List<Marker> pontos;

  const FormularioStip({super.key, required this.pontos});

  @override
  State<FormularioStip> createState() => _FormularioStipState();
}

class _FormularioStipState extends State<FormularioStip> {
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  @override
  void dispose() {
    _enderecoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Formulário STIP'),
        backgroundColor: const Color(0xFF4A90E2),
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