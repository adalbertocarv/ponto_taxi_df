import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapaController extends ChangeNotifier {
  bool _satelliteActive = false;
  final List<Marker> _markers = [];

  LatLng? _userLocation;
  MapController? _flutterMapController;
  Timer? _animationTimer;

  static const LatLng _initialCenter = LatLng(-15.79, -47.88);
  static const double _initialZoom = 15.0;
  static const String _userAgentPackage = 'com.ponto.certo.taxi.ponto_certo_taxi';

  // static const InteractionOptions _interactionOptions = InteractionOptions(
  //   flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  // );

  // Getters
  bool get satelliteActive => _satelliteActive;
  List<Marker> get markers => List.unmodifiable(_markers);
  LatLng get initialCenter => _initialCenter;
  double get initialZoom => _initialZoom;
  String get userAgentPackage => _userAgentPackage;
 // InteractionOptions get interactionOptions => _interactionOptions;
  LatLng? get userLocation => _userLocation;

  MapOptions get mapOptions => MapOptions(
    initialCenter: _initialCenter,
    initialZoom: _initialZoom,
 //   interactionOptions: _interactionOptions,
  );

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Define o controller do mapa
  void setFlutterMapController(MapController controller) {
    _flutterMapController = controller;
  }

  /// Obtém localização do usuário e move o mapa
  Future<void> obterLocalizacaoUsuario() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Serviço de localização desativado.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Permissão de localização negada.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Permissão de localização negada permanentemente.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      _userLocation = LatLng(position.latitude, position.longitude);

      _flutterMapController?.move(_userLocation!, 17.0);
      notifyListeners();
    } catch (e) {
      _showError('Erro ao obter localização: $e');
    }
  }

  /// Centraliza a localização do usuário com animação
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

  void _startCenteringAnimation(
      LatLng startPosition,
      LatLng targetPosition,
      double startZoom,
      double targetZoom) {
    const int duration = 350;
    const int steps = 30;
    const int interval = duration ~/ steps;

    int currentStep = 0;

    _animationTimer?.cancel();

    _animationTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      currentStep++;

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

  double _lerp(double start, double end, double progress) {
    return start + (end - start) * progress;
  }

  void resetarRotacaoParaNorte() {
    if (_flutterMapController != null) {
      _flutterMapController!.rotate(0);
      notifyListeners();
    } else {
      _showError('Mapa não inicializado.');
    }
  }


  /// Controle de satélite
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

  /// Controle de markers
  void adicionarMarker(LatLng posicao, {Widget? child}) {
    final marker = Marker(
      point: posicao,
      child: child ??
          const Icon(
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
        marker.point.longitude == posicao.longitude);
    notifyListeners();
  }

  void limparMarkers() {
    if (_markers.isNotEmpty) {
      _markers.clear();
      notifyListeners();
    }
  }

  int get totalMarkers => _markers.length;

  /// Resetar mapa
  void resetarMapa() {
    _satelliteActive = false;
    _markers.clear();
    _userLocation = null;
    notifyListeners();
  }

  /// Mensagens de erro
  void _showError(String message) {
    _errorMessage = message;
    notifyListeners();
    Timer(const Duration(seconds: 3), () {
      _errorMessage = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }
}
