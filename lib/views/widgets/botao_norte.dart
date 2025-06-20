import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../providers/themes/tema_provider.dart';

class BotaoNorte extends StatelessWidget {
  const BotaoNorte({super.key});

  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final themeProvider = context.watch<ThemeProvider>();

    return Positioned(
      top: 160,
      right: 16,
      child: FloatingActionButton.small(
        tooltip: 'Reorientar para o Norte',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: themeProvider.isDarkMode
            ? ThemeProvider.primaryColorDark
            : ThemeProvider.primaryColor,
        onPressed: () {
          mapaController.resetarRotacaoParaNorte();
        },
        child: const Icon(
          Icons.explore_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
