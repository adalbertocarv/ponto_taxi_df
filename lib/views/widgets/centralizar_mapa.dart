import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../providers/themes/tema_provider.dart';

class CentralizarMapa extends StatelessWidget {
  const CentralizarMapa({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final themeProvider = context.watch<ThemeProvider>();

    return Positioned(
      top: 110,
      right: 16,
      child: FloatingActionButton.small(
        tooltip: 'Centralizar localização',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: themeProvider.primaryColor,
          onPressed: () {
          mapaController.centralizarLocalizacaoUsuario();
        },
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }
}
