import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponto_taxi_df/taxi/views/screens/home/desktop/botao_modoclick.dart';
import 'package:provider/provider.dart';
// CONTROLLERS
import '../../controllers/mapa_controller.dart';
// PROVIDERS
import '../../controllers/modo_app_controller.dart';
import '../../models/constants/app_constants.dart';
import '../../providers/themes/map_themes.dart';
import '../../providers/themes/tema_provider.dart';
// WIDGETS
import '../widgets/barra_pesquisa.dart';
import '../widgets/botao_camada_satelite.dart';
import '../widgets/botoes_geral.dart';
import '../widgets/icone_central_mapa.dart';
import '../widgets/botao_confirmar_ponto.dart';
import '../widgets/botao_perfil.dart';
import 'detalhamento_edicao_ponto.dart';

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

class _MapaCadastrarContentState extends State<_MapaCadastrarContent>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool showBottomSheet = false;
  final LatLng markerLocation = LatLng(-15.798778, -47.87865); // Brasília
  static const _desktopBreakpoint = 780.0;

  void _onMarkerTapped() {
    setState(() => showBottomSheet = true);
    _animationController.forward();
  }

  void _closeBottomSheet() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() => showBottomSheet = false);
      }
    });
  }

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Inicializar controlador de animação
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

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
        setState(() => _isInitialized = true);
        await mapaController.obterLocalizacaoUsuario();
      }
    } catch (e) {
      debugPrint('Erro ao inicializar MapaController: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final modoApp = context.watch<ModoAppController>();

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer2<ThemeProvider, MapaController>(
      builder: (context, themeProvider, mapaController, child) {
        final baseTheme =
            themeProvider.isDarkMode ? AppMapThemes.dark : AppMapThemes.light;
        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: mapaController.mapOptions,
                children: [
                  TileLayer(
                    tileProvider: CancellableNetworkTileProvider(),
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
                      additionalOptions:
                          AppMapThemes.satellite.additionalOptions,
                      userAgentPackageName: mapaController.userAgentPackage,
                    ),
                  MarkerLayer(
                    markers: [
                      if (mapaController.userLocation != null)
                        Marker(
                          point: mapaController.userLocation!,
                          width: 45,
                          height: 45,
                          child: Transform.translate(
                            offset: const Offset(0, -20),
                            child: Image.asset(
                              'assets/images/icon_user.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                  MarkerLayer(markers: mapaController.markers),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: markerLocation,
                        width: 40,
                        height: 40,
                        child: modoApp.isVistoria
                            ? GestureDetector(
                                onTap: _onMarkerTapped,
                                child: const Icon(Icons.location_on,
                                    size: 40, color: Colors.red),
                              )
                            : const Icon(Icons.location_on,
                                size: 40, color: Colors.red),
                      ),
                    ],
                  ),
                  // const SimpleAttributionWidget(
                  //   source: Text('OpenStreetMap contributors'),
                  // ),
                  BotaoModoClick()

                ],
              ),
              if (showBottomSheet)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // Backdrop que permite fechar ao tocar fora
                        GestureDetector(
                          onTap: _closeBottomSheet,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ),
                        ),

                        // Bottom Sheet animado
                        SlideTransition(
                          position: _slideAnimation,
                          child: DraggableScrollableSheet(
                            controller: _draggableController,
                            initialChildSize: 0.4,
                            minChildSize: 0.2,
                            maxChildSize: 0.65,
                            builder: (context, scrollController) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, -4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Header fixo, fora do scroll
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onVerticalDragUpdate: (details) {
                                        final currentSize =
                                            _draggableController.size;
                                        final screenHeight =
                                            MediaQuery.of(context).size.height;
                                        if (screenHeight == 0) return;
                                        final newSize = currentSize -
                                            (details.primaryDelta! /
                                                screenHeight);
                                        _draggableController
                                            .jumpTo(newSize.clamp(0.2, 0.65));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: _closeBottomSheet,
                                              icon: Icon(Icons.close,
                                                  color: Colors.grey.shade600),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest
                                                        .withValues(alpha: 0.3),
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Conteúdo scrollável
                                    Expanded(
                                      child: ListView(
                                        controller: scrollController,
                                        padding: const EdgeInsets.fromLTRB(
                                            24, 8, 24, 32),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Informações do Ponto',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          _buildInfoCard(
                                            context,
                                            icon: Icons.location_on_outlined,
                                            iconColor: Colors.red.shade400,
                                            children: [
                                              _buildInfoRow(context, 'Endereço',
                                                  'Asa Norte SQN 410'),
                                              _buildInfoRow(context, 'Telefone',
                                                  '(61) 3321-8181'),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildInfoCard(
                                            context,
                                            icon: Icons.info_outline,
                                            iconColor: Colors.blue.shade400,
                                            children: [
                                              _buildInfoRow(context,
                                                  'Classificação', 'Edificado'),
                                              _buildInfoRow(context,
                                                  'Ponto Oficial', 'Sim'),
                                              _buildInfoRow(
                                                  context, 'Nº de Vagas', '4'),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildInfoCard(
                                            context,
                                            icon: Icons.settings_outlined,
                                            iconColor: Colors.green.shade400,
                                            children: [
                                              _buildChipRow(context, [
                                                _buildStatusChip(
                                                    'Sinalização', true),
                                                _buildStatusChip(
                                                    'Abrigo', true),
                                              ]),
                                              const SizedBox(height: 8),
                                              _buildChipRow(context, [
                                                _buildStatusChip(
                                                    'Energia', true),
                                                _buildStatusChip('Água', true),
                                              ]),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildInfoCard(
                                            context,
                                            icon: Icons.person_outline,
                                            iconColor: Colors.purple.shade400,
                                            children: [
                                              _buildInfoRow(
                                                  context,
                                                  'Autorizatário',
                                                  'Maria Santos - Num 002'),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          _buildInfoCard(
                                            context,
                                            icon: Icons.note_outlined,
                                            iconColor: Colors.orange.shade400,
                                            children: [
                                              Text(
                                                'Observações',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Não há obra a ser executada.',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                              alpha: 0.7),
                                                      height: 1.4,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 50),
                                            decoration: BoxDecoration(
                                              color: Colors.green[200],
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: modoApp.isCadastro
                                                    ? Colors.green.shade200
                                                    : Colors.grey.shade300,
                                                width: 1,
                                              ),
                                            ),
                                            child: TextButton(
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetalhamentoEdicaoPonto())),
                                                child: Text(
                                                  'Mais Detalhes',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.green[900]),
                                                )),
                                          ),
                                          SizedBox(
                                            height: (AppConstants
                                                    .navigationBarAltura +
                                                36),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              if (mapaController.iconeVisivel) IconeCentralMapa(),
              BotaoConfirmar(),
              BarraPesquisa(
                onSearch: (String query) {},
                onTap: () {},
              ),
              BotoesGeral(),
              CamadaSatelite(
                ativo: mapaController.satelliteActive,
                onToggle: mapaController.toggleSatellite,
              ),
              if (width <= _desktopBreakpoint) BotaoPerfil(),
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
                          Icon(Icons.check_circle,
                              color: Colors.green.shade700),
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

  // Método auxiliar para criar cards de informação
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método auxiliar para criar linhas de informação
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para criar linha de chips
  Widget _buildChipRow(BuildContext context, List<Widget> chips) {
    return Row(
      children: chips
          .map((chip) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: chip,
              ))
          .toList(),
    );
  }

  // Método auxiliar para criar chips de status
  Widget _buildStatusChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green.shade200 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade500 : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.green.shade700 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _draggableController.dispose();
    super.dispose();
  }
}
