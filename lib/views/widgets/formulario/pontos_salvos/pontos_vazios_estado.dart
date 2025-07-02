import 'package:flutter/material.dart';
class PontosVaziosEstado extends StatelessWidget {
  const PontosVaziosEstado({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_rounded,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhum ponto cadastrado',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Volte ao mapa e adicione pontos',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}