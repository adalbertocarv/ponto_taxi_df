import 'package:flutter/material.dart';

import 'custom_text_field.dart';
import 'formulario_header.dart';

class FormularioSection extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;

  const FormularioSection({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormularioHeader(),
          const SizedBox(height: 20),
          CustomTextField(
            controller: enderecoController,
            label: 'Endereço de Referência',
            icon: Icons.location_on_outlined,
            hint: 'Ex: Asa Norte SQN 410 - Asa Norte',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: observacoesController,
            label: 'Observações',
            icon: Icons.notes_rounded,
            hint: 'Informações adicionais sobre o ponto',
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}