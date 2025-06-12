import '../../models/tile_layer_model.dart';

class AppMapThemes {
  static const String _stadiaApiKey = 'f8bd75ba-79e3-4d8c-9387-49bffb7a19de';

  static final MapThemeData dark = MapThemeData(
    urlTemplate: 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key={apiKey}',
    additionalOptions: {'apiKey': _stadiaApiKey},
  );

  static final MapThemeData light = MapThemeData(
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/{style}/{z}/{x}/{y}{r}.png',
    additionalOptions: {'style': 'rastertiles/voyager_nolabels'},
    subdomains: ['a', 'b', 'c', 'd'],
  );
}