import 'package:flutter/material.dart';

class PontosSalvosHeader extends StatelessWidget {
  final int pontosCount;

  const PontosSalvosHeader({
    super.key,
    required this.pontosCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Color(0xFF4A90E2),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Pontos Cadastrados',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF27AE60),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$pontosCount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}