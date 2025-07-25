import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/mapa_controller.dart';

class SalvarButton extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;

  final VoidCallback onSalvar;

  const SalvarButton({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<MapaController>();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _salvarFormulario(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF27AE60),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Salvar Cadastro',
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

  Future<void> _salvarFormulario(BuildContext context) async {
    final mapaController = context.read<MapaController>();

    // Validação: precisa ter marcador
    if (mapaController.markers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(children: [
          Icon(Icons.warning, color: Colors.white),
          SizedBox(width: 8),
          Text('Adicione pelo menos um ponto no mapa!'),
        ]),
        backgroundColor: Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    ///  GRAVA NO BANCO
    onSalvar();

    // Diálogo de sucesso
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF27AE60)),
            SizedBox(width: 8),
            Text('Sucesso!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cadastro realizado com sucesso!'),
            const SizedBox(height: 8),
            Text('Ponto cadastrado: ${mapaController.markers.length}'),
            if (enderecoController.text.isNotEmpty)
              Text('Endereço: ${enderecoController.text}'),
            if (observacoesController.text.isNotEmpty)
              Text('Observações: ${observacoesController.text}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    mapaController.desfazerUltimoPonto();
    Navigator.of(context).popUntil((r) => r.isFirst);
  }
}