import 'package:flutter/material.dart';

class VoltarButton extends StatelessWidget {
  const VoltarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF4A90E2),
          side: const BorderSide(color: Color(0xFF4A90E2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Voltar ao Mapa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
