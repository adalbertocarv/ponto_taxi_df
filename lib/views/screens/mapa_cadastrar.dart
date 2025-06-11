import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '/views/widgets/botao_confirmar.dart';
import '/views/widgets/centralizar_mapa.dart';

import '../widgets/botao_norte.dart';

class MapaCadastrar extends StatefulWidget {
  const MapaCadastrar({super.key});

  @override
  State<MapaCadastrar> createState() => _MapaCadastrarState();
}

class _MapaCadastrarState extends State<MapaCadastrar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-15.79, -47.88),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              //Alfinete no centro da tela
              IgnorePointer(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //Definir latlong do ponto de taxi
          BotaoConfirmar(),
           CentralizarMapa(),
          BotaoNorte(),
        ],
      ),
    );
  }
}
