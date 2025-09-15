import 'package:flutter/material.dart';
import '../../models/tile_layer_model.dart';

class AppMapThemes {
  static final MapThemeData dark = MapThemeData(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/.png',
    tileBuilder: (context, tileWidget, tile) {
      return ColorFiltered(
        colorFilter: ColorFilter.matrix([
          -0.2126, -0.7152, -0.0722, 0, 255,
          -0.2126, -0.7152, -0.0722, 0, 255,
          -0.2126, -0.7152, -0.0722, 0, 255,
          0,       0,       0,       1, 0,
        ]),
        child: tileWidget,
      );
    },
  );

  static final MapThemeData light = MapThemeData(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  static final MapThemeData satellite = MapThemeData(
    urlTemplate: 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
    subdomains: [],
  );
}
