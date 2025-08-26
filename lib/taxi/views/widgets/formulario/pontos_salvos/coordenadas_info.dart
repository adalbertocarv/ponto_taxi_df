import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CoordenadasInfo extends StatelessWidget {
  final LatLng pontos;

  const CoordenadasInfo({
    super.key,
    required this.pontos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lat: ${pontos.latitude.toStringAsFixed(6)}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontFamily: 'monospace',
          ),
        ),
        Text(
          'Lng: ${pontos.longitude.toStringAsFixed(6)}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}