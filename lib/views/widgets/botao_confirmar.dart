import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../../controllers/mapa_controller.dart';

class BotaoConfirmar extends StatelessWidget {
    const BotaoConfirmar({super.key});

  @override

   Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Positioned(
      bottom: 90,
      left: 36,
      right: 36,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.isDarkMode
                ? ThemeProvider.primaryColorDark  // Cor escura para tema escuro
                : ThemeProvider.primaryColor,     // Cor original para tema claro
          ),
          onPressed: () {
            // Adiciona marker exatamente onde o IconeCentralMapa está posicionado
            mapaController.adicionarMarkerNoCentro();
          },
          child: const Text(
            'Cadastrar',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );

  }
}
