import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class MapaController extends ChangeNotifier {
  // Estado do satélite
  bool _satelliteActive = false;

  // Lista de markers
  final List<Marker> _markers = [];

  // Localização do usuário e controlador do mapa
  LatLng? _userLocation;
  MapController? _flutterMapController;
  Timer? _animationTimer;

  // Configurações do mapa
  static const LatLng _initialCenter = LatLng(-15.79, -47.88);
  static const double _initialZoom = 15.0;
  static const String _userAgentPackage = 'com.ponto.certo.taxi.ponto_certo_taxi';

  // Configurações de interação do mapa
  static const InteractionOptions _interactionOptions = InteractionOptions(
    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  );

  // Getters
  bool get satelliteActive => _satelliteActive;
  List<Marker> get markers => List.unmodifiable(_markers);
  LatLng get initialCenter => _initialCenter;
  double get initialZoom => _initialZoom;
  String get userAgentPackage => _userAgentPackage;
  InteractionOptions get interactionOptions => _interactionOptions;
  LatLng? get userLocation => _userLocation;

  // Getter para MapOptions completo
  MapOptions get mapOptions => MapOptions(
    initialCenter: _initialCenter,
    initialZoom: _initialZoom,
    interactionOptions: _interactionOptions,
  );

  // Método para definir o controller do FlutterMap
  void setFlutterMapController(MapController controller) {
    _flutterMapController = controller;
  }

  // Método para definir localização do usuário
  void setUserLocation(LatLng location) {
    _userLocation = location;
    notifyListeners();
  }

  // MÉTODO DE CENTRALIZAÇÃO - IMPLEMENTADO NO CONTROLLER
  void centralizarLocalizacaoUsuario() {
    if (_userLocation == null) {
      _showError('Localização do usuário não disponível.');
      return;
    }

    if (_flutterMapController == null) {
      _showError('Mapa não inicializado.');
      return;
    }

    LatLng startPosition = _flutterMapController!.camera.center;
    LatLng targetPosition = _userLocation!;
    double startZoom = _flutterMapController!.camera.zoom;
    double targetZoom = 17.0;

    _startCenteringAnimation(startPosition, targetPosition, startZoom, targetZoom);
  }

  // Método privado para executar a animação
  void _startCenteringAnimation(
      LatLng startPosition,
      LatLng targetPosition,
      double startZoom,
      double targetZoom
      ) {
    const int duration = 350; // ms
    const int steps = 30;
    const int interval = duration ~/ steps;

    int currentStep = 0;

    // Cancela animação anterior se existir
    _animationTimer?.cancel();

    _animationTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      currentStep++;

      // Interpola posição e zoom
      double progress = currentStep / steps;
      double lat = _lerp(startPosition.latitude, targetPosition.latitude, progress);
      double lng = _lerp(startPosition.longitude, targetPosition.longitude, progress);
      double zoom = _lerp(startZoom, targetZoom, progress);

      _flutterMapController!.move(LatLng(lat, lng), zoom);

      if (currentStep >= steps) {
        timer.cancel();
        _animationTimer = null;
      }
    });
  }

  // Interpolação linear
  double _lerp(double start, double end, double progress) {
    return start + (end - start) * progress;
  }

  // Método para mostrar erros (será chamado pela View)
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _showError(String message) {
    _errorMessage = message;
    notifyListeners();
    // Limpa o erro após um tempo
    Timer(const Duration(seconds: 3), () {
      _errorMessage = null;
      notifyListeners();
    });
  }

  // Método para centralizar sem animação (mais simples)
  void centralizarLocalizacaoUsuarioInstantaneo() {
    if (_userLocation != null && _flutterMapController != null) {
      _flutterMapController!.move(_userLocation!, 17.0);
    }
  }
  // Métodos de controle do satélite
  void toggleSatellite() {
    _satelliteActive = !_satelliteActive;
    notifyListeners();
  }

  void ativarSatellite() {
    if (!_satelliteActive) {
      _satelliteActive = true;
      notifyListeners();
    }
  }

  void desativarSatellite() {
    if (_satelliteActive) {
      _satelliteActive = false;
      notifyListeners();
    }
  }

  // Métodos de controle dos markers
  void adicionarMarker(LatLng posicao, {Widget? child, String? id}) {
    final marker = Marker(
      point: posicao,
      child: child ?? const Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    );
    _markers.add(marker);
    notifyListeners();
  }

  void removerMarker(int index) {
    if (index >= 0 && index < _markers.length) {
      _markers.removeAt(index);
      notifyListeners();
    }
  }

  void removerMarkerPorPosicao(LatLng posicao) {
    _markers.removeWhere((marker) =>
    marker.point.latitude == posicao.latitude &&
        marker.point.longitude == posicao.longitude
    );
    notifyListeners();
  }

  void limparMarkers() {
    if (_markers.isNotEmpty) {
      _markers.clear();
      notifyListeners();
    }
  }

  int get totalMarkers => _markers.length;

  // Método para resetar o estado do mapa
  void resetarMapa() {
    _satelliteActive = false;
    _markers.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }
}