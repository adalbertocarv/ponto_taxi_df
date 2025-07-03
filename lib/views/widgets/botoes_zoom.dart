import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

import '../../providers/themes/tema_provider.dart';


class BotoesZoom extends StatefulWidget {
  const BotoesZoom({super.key});

  @override
  State<BotoesZoom> createState() => _BotoesZoomState();
}

class _BotoesZoomState extends State<BotoesZoom> {
  final MapController _mapController = MapController();
  bool _isSatelliteMode = false;


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      children: [
         Positioned(
          top: MediaQuery.of(context).padding.top + 260,
          right: 10,
          child: Column(
            children: [
              // Botão de alternar vista satélite
              FloatingActionButton.small(
                heroTag: "satellite",
                onPressed: () {
                  setState(() {
                    _isSatelliteMode = !_isSatelliteMode;
                  });
                },
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[800]
                    : Colors.white,
                child: Icon(
                  _isSatelliteMode ? Icons.map : Icons.satellite,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Botões de zoom
              FloatingActionButton.small(
                heroTag: "zoom_in",
                onPressed: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  );
                },
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[800]
                    : Colors.white,
                child: Icon(
                  Icons.add,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              FloatingActionButton.small(
                heroTag: "zoom_out",
                onPressed: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  );
                },
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[800]
                    : Colors.white,
                child: Icon(
                  Icons.remove,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),

        // Indicador de zoom atual
        Positioned(
          bottom: 100,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? Colors.black.withValues(alpha:0.7)
                  : Colors.white.withValues(alpha:0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: StreamBuilder(
              stream: _mapController.mapEventStream,
              builder: (context, snapshot) {
                return Text(
                  'Zoom: ${_mapController.camera.zoom.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
