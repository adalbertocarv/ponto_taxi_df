import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'ponto_mapa.dart';

class PontosLista extends StatelessWidget {
  final List<Marker> pontos;

  const PontosLista({
    super.key,
    required this.pontos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: pontos.map((marker) {
        return PontoCard(marker: marker);
      }).toList(),
    );
  }
}

// widgets/ponto_card.dart
class PontoCard extends StatelessWidget {
  final Marker marker;

  const PontoCard({
    super.key,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
    return
      PontoMapa(pontos: marker);
//       Container(
// //      padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: const Color(0xFFE9ECEF),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
  }
}