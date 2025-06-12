import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponto_taxi_df/views/widgets/botao_camada_satelite.dart';
import 'package:ponto_taxi_df/views/widgets/botoes_zoom.dart';
import 'package:provider/provider.dart';
import '../../models/tile_layer_model.dart';
import '../../providers/themes/Map_themes.dart';
import '../../providers/themes/tema_provider.dart';
import '../widgets/icone_central_mapa.dart';
import '/views/widgets/botao_confirmar.dart';
import '/views/widgets/centralizar_mapa.dart';
import '/views/widgets/botao_norte.dart';

class MapaCadastrar extends StatefulWidget {
  const MapaCadastrar({super.key});

  @override
  State<MapaCadastrar> createState() => _MapaCadastrarState();
}

class _MapaCadastrarState extends State<MapaCadastrar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mapTheme = themeProvider.isDarkMode ? AppMapThemes.dark : AppMapThemes.light;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-15.79, -47.88),
              initialZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: mapTheme.urlTemplate,
                additionalOptions: mapTheme.additionalOptions,
                subdomains: mapTheme.subdomains,
                userAgentPackageName: 'com.ponto.certo.taxi.ponto_certo_taxi',
              ),
              // Alfinete no centro da tela
              IconeCentralMapa(isDarkMode: themeProvider.isDarkMode),
            ],
          ),

          // Definir latlong do ponto de taxi
          BotaoConfirmar(),
          CentralizarMapa(),
          BotaoNorte(),
          CamadaSatelite(),
        ],
      ),
    );
  }
}
