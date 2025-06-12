// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:provider/provider.dart';
// import '../providers/themes/tema_provider.dart';
//
// class MapLayerConfig {
//   static const String _stadiaApiKey = 'f8bd75ba-79e3-4d8c-9387-49bffb7a19de';
//
//   static TileLayer build(BuildContext context) {
//     // Acessa o seu provider de tema através do contexto
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
//
//     return TileLayer(
//       urlTemplate: themeProvider.isDarkMode
//           ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key={apiKey}'
//           : 'https://{s}.basemaps.cartocdn.com/{style}/{z}/{x}/{y}{r}.png',
//
//       additionalOptions: themeProvider.isDarkMode
//           ? {'apiKey': _stadiaApiKey}
//           : {'style': 'rastertiles/voyager_nolabels'},
//
//       subdomains: themeProvider.isDarkMode ? [] : ['a', 'b', 'c', 'd'],
//
//       userAgentPackageName: 'com.ponto.certo.taxi.ponto_certo_taxi',
//     );
//   }
// }

class MapThemeData {
  final String urlTemplate;
  final Map<String, String> additionalOptions;
  final List<String> subdomains;

  const MapThemeData({
    required this.urlTemplate,
    this.additionalOptions = const {},
    this.subdomains = const [],
  });
}