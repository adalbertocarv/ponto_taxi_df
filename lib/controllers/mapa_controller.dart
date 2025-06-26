import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapaController extends ChangeNotifier {
  bool _satelliteActive = false;
  final List<Marker> _markers = [];
  bool _disposed = false;

  LatLng? _userLocation;
  MapController? _flutterMapController;
  Timer? _animationTimer;
  Timer? _errorTimer;

  static const LatLng _initialCenter = LatLng(-15.79, -47.88);
  static const double _initialZoom = 15.0;
  static const String _userAgentPackage = 'com.ponto.certo.taxi.ponto_certo_taxi';

  String? _errorMessage;

  // Getters
  bool get satelliteActive => _satelliteActive;
  List<Marker> get markers => List.unmodifiable(_markers);
  LatLng get initialCenter => _initialCenter;
  double get initialZoom => _initialZoom;
  String get userAgentPackage => _userAgentPackage;
  LatLng? get userLocation => _userLocation;
  String? get errorMessage => _errorMessage;

  MapOptions get mapOptions => MapOptions(
    initialCenter: _initialCenter,
    initialZoom: _initialZoom,
    onMapEvent: (MapEvent event) {
      if (event is MapEventRotateEnd || event is MapEventRotate) {
        final angle = _flutterMapController?.camera.rotation ?? 0.0;
        corrigirRotacaoSeNecessario(angle);
      }
    },
  );

  /// Define o controller do mapa
  void setFlutterMapController(MapController controller) {
    if (_disposed) return;
    _flutterMapController = controller;
  }

  /// Corrige rotações pequenas acidentais
  void corrigirRotacaoSeNecessario(double rotacao) {
    const double threshold = 3; // grau — rotação menor que isso será anulada
    if (rotacao.abs() < threshold) {
      _flutterMapController?.rotate(0);
    }
  }


  /// Obtém localização do usuário e move o mapa
  Future<void> obterLocalizacaoUsuario() async {
    if (_disposed) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (_disposed) return;

      if (!serviceEnabled) {
        _showError('Serviço de localização desativado.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (_disposed) return;

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (_disposed) return;

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
      if (_disposed) return;

      _userLocation = LatLng(position.latitude, position.longitude);
      _flutterMapController?.move(_userLocation!, 17.0);
      _safeNotifyListeners();
    } catch (e) {
      if (!_disposed) {
        _showError('Erro ao obter localização: $e');
      }
    }
  }

  /// Centraliza a localização do usuário com animação
  void centralizarLocalizacaoUsuario() {
    if (_disposed) return;

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

  void _startCenteringAnimation(LatLng startPosition, LatLng targetPosition, double startZoom, double targetZoom) {
    if (_disposed) return;

    const int duration = 350;
    const int steps = 30;
    const int interval = duration ~/ steps;

    int currentStep = 0;

    _animationTimer?.cancel();

    _animationTimer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }

      currentStep++;

      double progress = currentStep / steps;
      double lat = _lerp(startPosition.latitude, targetPosition.latitude, progress);
      double lng = _lerp(startPosition.longitude, targetPosition.longitude, progress);
      double zoom = _lerp(startZoom, targetZoom, progress);

      _flutterMapController?.move(LatLng(lat, lng), zoom);

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
    if (_disposed) return;

    if (_flutterMapController != null) {
      _flutterMapController!.rotate(0);
      _safeNotifyListeners();
    } else {
      _showError('Mapa não inicializado.');
    }
  }

  /// Controle de satélite
  void toggleSatellite() {
    if (_disposed) return;
    _satelliteActive = !_satelliteActive;
    _safeNotifyListeners();
  }

  void ativarSatellite() {
    if (_disposed) return;
    if (!_satelliteActive) {
      _satelliteActive = true;
      _safeNotifyListeners();
    }
  }

  void desativarSatellite() {
    if (_disposed) return;
    if (_satelliteActive) {
      _satelliteActive = false;
      _safeNotifyListeners();
    }
  }

  /// Controle de markers
  void adicionarMarker(LatLng posicao, {Widget? child}) {
    if (_disposed) return;

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
    _safeNotifyListeners();
  }

  /// método Adiciona marker no centro atual do mapa
  void adicionarMarkerNoCentro({Widget? child}) {
    if (_disposed) return;

    if (_flutterMapController == null) {
      _showError('Mapa não inicializado.');
      return;
    }

    final posicaoCentral = _flutterMapController!.camera.center;
    adicionarMarker(
      posicaoCentral,
      child: child ??
          Transform.translate(
            offset: const Offset(0, -20),
            child: Icon(
              Icons.location_pin,
              color: Colors.green,
              size: 40,
            ),
          ),
    );
  }

  void removerMarker(int index) {
    if (_disposed) return;

    if (index >= 0 && index < _markers.length) {
      _markers.removeAt(index);
      _safeNotifyListeners();
    }
  }

  void removerMarkerPorPosicao(LatLng posicao) {
    if (_disposed) return;

    _markers.removeWhere(
          (marker) =>
      marker.point.latitude == posicao.latitude &&
          marker.point.longitude == posicao.longitude,
    );
    _safeNotifyListeners();
  }

  void limparMarkers() {
    if (_disposed) return;

    if (_markers.isNotEmpty) {
      _markers.clear();
      _safeNotifyListeners();
    }
  }

  int get totalMarkers => _markers.length;

  /// Resetar mapa
  void resetarMapa() {
    if (_disposed) return;

    _satelliteActive = false;
    _markers.clear();
    _userLocation = null;
    _safeNotifyListeners();
  }

  /// Mensagens de erro
  void _showError(String message) {
    if (_disposed) return;

    _errorMessage = message;
    _safeNotifyListeners();

    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 3), () {
      if (!_disposed) {
        _errorMessage = null;
        _safeNotifyListeners();
      }
    });
  }

  /// Método seguro para notifyListeners
  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _animationTimer?.cancel();
    _errorTimer?.cancel();
    _animationTimer = null;
    _errorTimer = null;
    super.dispose();
  }
}
