import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponto_taxi_df/views/widgets/botao_perfil.dart';
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
    return ChangeNotifierProvider(
      create: (_) => MapaController(),
      child: const _MapaCadastrarContent(),
    );
  }
}

class _MapaCadastrarContent extends StatefulWidget {
  const _MapaCadastrarContent();

  @override
  State<_MapaCadastrarContent> createState() => _MapaCadastrarContentState();
}

class _MapaCadastrarContentState extends State<_MapaCadastrarContent> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Delay para garantir que o Provider já esteja disponível
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mapaController = context.read<MapaController>();
      mapaController.setFlutterMapController(_mapController);
      mapaController.obterLocalizacaoUsuario(); // Opcional: já busca a localização ao abrir
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final mapaController = context.watch<MapaController>();

    final baseTheme = themeProvider.isDarkMode
        ? AppMapThemes.dark
        : AppMapThemes.light;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: mapaController.mapOptions,
            children: [
              TileLayer(
                urlTemplate: baseTheme.urlTemplate,
                subdomains: baseTheme.subdomains,
                tileBuilder: baseTheme.tileBuilder,
                additionalOptions: baseTheme.additionalOptions,
                userAgentPackageName: mapaController.userAgentPackage,
              ),
              if (mapaController.satelliteActive)
                TileLayer(
                  urlTemplate: AppMapThemes.satellite.urlTemplate,
                  subdomains: AppMapThemes.satellite.subdomains,
                  additionalOptions: AppMapThemes.satellite.additionalOptions,
                  userAgentPackageName: mapaController.userAgentPackage,
                ),
              MarkerLayer(
                markers: mapaController.markers,
              ),
              IconeCentralMapa(isDarkMode: themeProvider.isDarkMode),
            ],
          ),

          /// Seus botões e widgets flutuantes
          const BotaoConfirmar(),
          const CentralizarMapa(),
          const BotaoNorte(),
          CamadaSatelite(
            ativo: mapaController.satelliteActive,
            onToggle: mapaController.toggleSatellite,
          ),
          BotaoPerfil(),
        ],
      ),
    );
  }
}
