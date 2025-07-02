import 'package:flutter/material.dart';

class FormularioHeader extends StatelessWidget {
  const FormularioHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF27AE60).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.edit_document,
            color: Color(0xFF27AE60),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Informações Adicionais',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}
