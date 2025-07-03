import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
//CONTROLLERS
import '../../controllers/mapa_controller.dart';
//PROVIDERS
import '../../providers/themes/map_themes.dart';
import '../../providers/themes/tema_provider.dart';
//WIDGETS
import '../widgets/botao_camada_satelite.dart';
,import '../widgets/icone_central_mapa.dart';
import '../widgets/botao_confirmar_ponto.dart';
import '../widgets/centralizar_mapa.dart';
import '../widgets/botao_norte.dart';
import '../widgets/botao_perfil.dart';

class MapaCadastrar extends StatelessWidget {
  const MapaCadastrar({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapaCadastrarContent();
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
                    markers: [
                      if (mapaController.userLocation != null)
                        Marker(
                          point: mapaController.userLocation!, // LatLng do usuário
                          width: 78,
                          height: 78,
                          child: Transform.translate(
                            offset: const Offset(0, -20),
                          child: Image.asset(
                            'assets/images/icon_user.webp',
                            fit: BoxFit.contain,
                          ),
                          ),
                        ),
                    ],
                  ),
                  MarkerLayer(
                    markers: mapaController.markers,
                  ),
                  // Mostrar o ícone central apenas se _iconeVisivel for verdadeiro
                  if (mapaController.iconeVisivel) IconeCentralMapa(),                ],
              ),
              /// Seus botões e widgets flutuantes
             //Botão excluir saiu pq foi substituido por outro
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
              // Mostrar mensagem de sucesso se houver
              if (mapaController.successMessage != null)
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
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mapaController.successMessage!,
                              style: TextStyle(
                                color: Colors.green.shade700,
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