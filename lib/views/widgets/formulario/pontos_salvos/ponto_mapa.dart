import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class PontoMapa extends StatelessWidget {
  final Marker pontos;

  const PontoMapa({
    super.key,
    required this.pontos,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 300,
        width: 300,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: pontos.point,
            initialZoom: 16.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: pontos.point,
                  width: 45.0,
                  height: 45.0,
                  child: Transform.translate(
                    offset: const Offset(0, -22),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.green,
                      size: 45,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}