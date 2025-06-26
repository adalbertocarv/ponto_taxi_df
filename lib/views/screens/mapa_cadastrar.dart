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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Inicialização mais segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMapController();
    });
  }

  Future<void> _initializeMapController() async {
    if (!mounted) return;

    try {
      final mapaController = context.read<MapaController>();
      mapaController.setFlutterMapController(_mapController);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Buscar localização após inicialização
        await mapaController.obterLocalizacaoUsuario();
      }
    } catch (e) {
      debugPrint('Erro ao inicializar MapaController: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer2<ThemeProvider, MapaController>(
      builder: (context, themeProvider, mapaController, child) {
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
               BotaoConfirmar(),
              const CentralizarMapa(),
              const BotaoNorte(),
              CamadaSatelite(
                ativo: mapaController.satelliteActive,
                onToggle: mapaController.toggleSatellite,
              ),
              BotaoPerfil(),

              // Mostrar mensagem de erro se houver
              if (mapaController.errorMessage != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mapaController.errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // O ChangeNotifierProvider já cuida do dispose do MapaController
    super.dispose();
  }
}