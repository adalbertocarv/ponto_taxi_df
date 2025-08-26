import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/mapa_controller.dart';
import '../../../../providers/themes/map_themes.dart';
import '../../../../providers/themes/tema_provider.dart';

class PontoMapa extends StatelessWidget {
  final Marker pontos;

  const PontoMapa({
    super.key,
    required this.pontos,
  });

  @override
  Widget build(BuildContext context) {
    final mapaController = context.read<MapaController>();
    final themeProvider = context.watch<ThemeProvider>();
    final baseTheme = themeProvider.isDarkMode
        ? AppMapThemes.dark
        : AppMapThemes.light;

    final minZoom = mapaController.minZoom;
    final minimoZoomMiniMapa = minZoom +4;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 300,
        width: 400,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: pontos.point,
            initialZoom: 16.0,
            minZoom: minimoZoomMiniMapa,
            maxZoom: mapaController.maxZoom,
            //limitar a interação do mapa ao máximo
            interactionOptions: const InteractionOptions(
              enableMultiFingerGestureRace: true,
              flags:
              InteractiveFlag.doubleTapDragZoom |
              InteractiveFlag.doubleTapZoom |
              InteractiveFlag.drag |
              InteractiveFlag.flingAnimation |
              InteractiveFlag.pinchZoom |
              InteractiveFlag.scrollWheelZoom,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: baseTheme.urlTemplate,
              subdomains: baseTheme.subdomains,
              tileBuilder: baseTheme.tileBuilder,
              additionalOptions: baseTheme.additionalOptions,
              userAgentPackageName: mapaController.userAgentPackage,
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