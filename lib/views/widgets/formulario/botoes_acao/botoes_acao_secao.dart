import 'package:flutter/material.dart';
import 'salvar_botao.dart';
import 'voltar_botao.dart';

class BotoesAcaoSecao extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final VoidCallback onSalvar;

  const BotoesAcaoSecao({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.onSalvar
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SalvarButton(
          enderecoController: enderecoController,
          observacoesController: observacoesController,
          onSalvar: onSalvar,
        ),
        const SizedBox(height: 12),
        const VoltarButton(),
      ],
    );
  }
}