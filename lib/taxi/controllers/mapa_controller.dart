import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapaController extends ChangeNotifier {
  bool _satelliteActive = false;
  final List<Marker> _pontos = [];
  bool _disposed = false;

  LatLng? _userLocation;
  MapController? _flutterMapController;
  Timer? _animationTimer;
  Timer? _errorTimer;
  Timer? _successTimer; // Adicionado timer para mensagens de sucesso

  static const LatLng _initialCenter = LatLng(-15.79, -47.88);
  static const double _initialZoom = 15.0;
  static const double _minZoom = 10;
  static const double _maxZoom = 20;
  static const String _userAgentPackage = 'com.ponto.certo.taxi.ponto_certo_taxi';
  bool iconeVisivel = true; // Controla a visibilidade do IconeCentralMapa

  String? _errorMessage;
  String? _successMessage; // Adicionado para mensagens de sucesso

  // Getters
  bool get satelliteActive => _satelliteActive;
  List<Marker> get markers => List.unmodifiable(_pontos);
  LatLng get initialCenter => _initialCenter;
  double get initialZoom => _initialZoom;
  double get minZoom => _minZoom;
  double get maxZoom => _maxZoom;
  String get userAgentPackage => _userAgentPackage;
  LatLng? get userLocation => _userLocation;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage; // Getter para mensagens de sucesso

  MapOptions get mapOptions => MapOptions(
    initialCenter: _initialCenter,
    initialZoom: _initialZoom,
    minZoom: _minZoom,
    maxZoom: _maxZoom,
    onMapEvent: (MapEvent event) {
      if (event is MapEventRotateEnd || event is MapEventRotate) {
        final angle = _flutterMapController?.camera.rotation ?? 0.0;
        corrigirRotacao(angle);
      }
    },
  );

  /// Define o controller do mapa
  void setFlutterMapController(MapController controller) {
    if (_disposed) return;
    _flutterMapController = controller;
  }

  /// Corrige rotações pequenas acidentais
  void corrigirRotacao(double rotacao) {
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
        showError('Serviço de localização desativado.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (_disposed) return;

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (_disposed) return;

        if (permission == LocationPermission.denied) {
          showError('Permissão de localização negada.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showError('Permissão de localização negada permanentemente.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      if (_disposed) return;

      _userLocation = LatLng(position.latitude, position.longitude);
      _flutterMapController?.move(_userLocation!, 17.0);
      _safeNotifyListeners();
    } catch (e) {
      if (!_disposed) {
        showError('Erro ao obter localização: $e');
      }
    }
  }
  ///--------------funcionamento-notificacoes---------------------
  void clearErrorMessage() {
    if (_disposed) return;
    _errorMessage = null;
    _safeNotifyListeners();
  }

  void clearSuccessMessage() {
    if (_disposed) return;
    _successMessage = null;
    _safeNotifyListeners();
  }
  //---------------------------------
  /// Centraliza a localização do usuário com animação
  void centralizarLocalizacaoUsuario() {
    if (_disposed) return;

    if (_userLocation == null) {
      showError('Localização do usuário não disponível.');
      return;
    }

    if (_flutterMapController == null) {
      showError('Mapa não inicializado.');
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
      showError('Mapa não inicializado.');
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
    _pontos.add(marker);
    _safeNotifyListeners();
  }

  // método Adiciona marker no centro atual do mapa
  void adicionarMarkerNoCentro({Widget? child}) {
    if (_disposed) return;

    if (_flutterMapController == null) {
      showError('Mapa não inicializado.');
      return;
    }

    final posicaoCentral = _flutterMapController!.camera.center;

    // Adiciona o marcador no centro
    final marker = Marker(
      point: posicaoCentral,
      child: child ??
          Transform.translate(
            offset: const Offset(-6, -26),
            child: Icon(
              Icons.location_on_rounded,
              color: Colors.green,
              size: 42,
            ),
          ),
    );
    _pontos.add(marker);

    // Oculta o ícone central
    iconeVisivel = false;

    // Amplia o mapa para o marker criado com animação
    _ampliarParaMarker(posicaoCentral);

    // Mostra mensagem de sucesso
    showSuccess('Ponto confirmado!');

    _safeNotifyListeners();
  }

  /// Amplia o mapa para a posição do marker com animação
  void _ampliarParaMarker(LatLng posicao) {
    if (_disposed || _flutterMapController == null) return;

    LatLng startPosition = _flutterMapController!.camera.center;
    double startZoom = _flutterMapController!.camera.zoom;
    double targetZoom = 18.0; // Zoom mais próximo para destacar o marker

    _startCenteringAnimation(startPosition, posicao, startZoom, targetZoom);
  }

  /// Mostra novamente o ícone central (útil para adicionar novos markers)
  void mostrarIconeCentral() {
    if (_disposed) return;
    iconeVisivel = true;
    _safeNotifyListeners();
  }

  /// Oculta o ícone central
  void ocultarIconeCentral() {
    if (_disposed) return;
    iconeVisivel = false;
    _safeNotifyListeners();
  }

  void removerMarker(int index) {
    if (_disposed) return;

    if (index >= 0 && index < _pontos.length) {
      _pontos.removeAt(index);
      _safeNotifyListeners();
    }
  }

  void removerMarkerPorPosicao(LatLng posicao) {
    if (_disposed) return;

    _pontos.removeWhere(
          (marker) =>
      marker.point.latitude == posicao.latitude &&
          marker.point.longitude == posicao.longitude,
    );
    _safeNotifyListeners();
  }

  void limparMarkers() {
    if (_disposed) return;

    if (_pontos.isNotEmpty) {
      _pontos.clear();
      _safeNotifyListeners();
    }
  }

  void desfazerUltimoPonto() {
    if (_pontos.isNotEmpty) {
      _pontos.removeLast();          // remove o último marker
    }
    mostrarIconeCentral();           // volta a exibir o ícone central
    _safeNotifyListeners();
  }

  int get totalMarkers => markers.length;

  /// Resetar mapa
  void resetarMapa() {
    if (_disposed) return;

    _satelliteActive = false;
    _pontos.clear();
    _userLocation = null;
    iconeVisivel = true; // Restaura o ícone central quando resetar o mapa
    _safeNotifyListeners();
  }

  /// Mensagens de erro
  void showError(String message) {
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


  /// Mensagens de sucesso (seguindo o mesmo padrão das mensagens de erro)
  void showSuccess(String message) {
    if (_disposed) return;

    _successMessage = message;
    _safeNotifyListeners();

    _successTimer?.cancel();
    _successTimer = Timer(const Duration(seconds: 3), () {
      if (!_disposed) {
        _successMessage = null;
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
    _successTimer?.cancel(); // Cancela o timer de sucesso
    _animationTimer = null;
    _errorTimer = null;
    _successTimer = null; // Limpa a referência
    super.dispose();
  }
}