import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../providers/themes/tema_provider.dart';

class BotaoExcluirMarker extends StatefulWidget {
  const BotaoExcluirMarker({super.key});

  @override
  State<BotaoExcluirMarker> createState() => _BotaoExcluirMarkerState();
}

class _BotaoExcluirMarkerState extends State<BotaoExcluirMarker> {
  @override
  Widget build(BuildContext context) {
    final mapaController = context.watch<MapaController>();
    final themeProvider = context.watch<ThemeProvider>();

    // Se o ícone não for visível, retorna um widget vazio (não exibe o botão)
    if (mapaController.iconeVisivel) {
      return SizedBox.shrink();  // Retorna um widget vazio, garantindo que o tipo não seja nulo
    }

    // Caso o ícone esteja visível, retorna o botão
    return Positioned(
      top: 160,
      left: 16,
      child: FloatingActionButton.small(
        heroTag: 'Excluir Marcador',
        tooltip: 'Excluir Marcador',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: themeProvider.primaryColor,
          onPressed: () {
          mapaController.limparMarkers();
        },
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }
}
