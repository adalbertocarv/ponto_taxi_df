import 'package:flutter/material.dart';
import 'salvar_botao.dart';
import 'voltar_botao.dart';

class BotoesAcaoSecao extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;

  const BotoesAcaoSecao({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SalvarButton(
          enderecoController: enderecoController,
          observacoesController: observacoesController,
        ),
        const SizedBox(height: 12),
        const VoltarButton(),
      ],
    );
  }
}