import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/themes/tema_provider.dart';

class FormularioHeader extends StatelessWidget {
  const FormularioHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

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
        Text(
          'Informações Adicionais',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode
                ? Colors.white
                : const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}
