import 'package:flutter_map/flutter_map.dart';

class MapThemeData {
  final String urlTemplate;
  final Map<String, String> additionalOptions;
  final List<String> subdomains;
  final TileBuilder? tileBuilder;

  const MapThemeData({
    required this.urlTemplate,
    this.additionalOptions = const {},
    this.subdomains = const [],
    this.tileBuilder,
  });
}