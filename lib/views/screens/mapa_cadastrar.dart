import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../controllers/mapa_controller.dart';
import '../../providers/themes/map_themes.dart';
import '../../providers/themes/tema_provider.dart';
import '../widgets/botao_camada_satelite.dart';
import '../widgets/icone_central_mapa.dart';
import '/views/widgets/botao_confirmar.dart';
import '/views/widgets/centralizar_mapa.dart';
import '/views/widgets/botao_norte.dart';

class MapaCadastrar extends StatelessWidget {
  const MapaCadastrar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapaController()),
      ],
      child: const _MapaCadastrarContent(),
    );
  }
}

class _MapaCadastrarContent extends StatelessWidget {
  const _MapaCadastrarContent();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mapaController = Provider.of<MapaController>(context);

    final baseTheme = themeProvider.isDarkMode
        ? AppMapThemes.dark
        : AppMapThemes.light;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-15.79, -47.88),
              initialZoom: 15,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: baseTheme.urlTemplate,
                subdomains: baseTheme.subdomains,
                tileBuilder: baseTheme.tileBuilder,
                additionalOptions: baseTheme.additionalOptions,
                userAgentPackageName: 'com.ponto.certo.taxi.ponto_certo_taxi',
              ),
              if (mapaController.satelliteActive)
                TileLayer(
                  urlTemplate: AppMapThemes.satellite.urlTemplate,
                  subdomains: AppMapThemes.satellite.subdomains,
                  additionalOptions: AppMapThemes.satellite.additionalOptions,
                  userAgentPackageName: 'com.ponto.certo.taxi.ponto_certo_taxi',
                ),
              IconeCentralMapa(isDarkMode: themeProvider.isDarkMode),
            ],
          ),
          const BotaoConfirmar(),
          const CentralizarMapa(),
          const BotaoNorte(),
          CamadaSatelite(
            ativo: mapaController.satelliteActive,
            onToggle: mapaController.toggleSatellite,
          ),
        ],
      ),
    );
  }
}