import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'pontos_vazios_estado.dart';
import 'pontos_lista.dart';
import 'pontos_salvos_header.dart';

class PontosSalvosSecao extends StatelessWidget {
  final List<Marker> pontos;

  const PontosSalvosSecao({
    super.key,
    required this.pontos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          PontosSalvosHeader(pontosCount: pontos.length),
          const SizedBox(height: 16),
          if (pontos.isEmpty)
            const PontosVaziosEstado()
          else
            PontosLista(pontos: pontos),
        ],
      ),
    );
  }
}