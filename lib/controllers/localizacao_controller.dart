
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocalizacaoController {
  LatLng? userLocation;

  Future<LatLng?> obterLocalizacaoUsuario() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition();
      userLocation = LatLng(position.latitude, position.longitude);
      return userLocation;
    } catch (e) {
      return null;
    }
  }
}
