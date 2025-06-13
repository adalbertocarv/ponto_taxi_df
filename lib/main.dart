import 'package:flutter/material.dart';

import 'controllers/mapa_controller.dart';
import 'views/screens/telainicio.dart';
import 'package:provider/provider.dart';
import 'providers/themes/tema_provider.dart';

void main() {
  runApp(
MultiProvider(providers: [ChangeNotifierProvider(create: (_) => MapaController()),
  ChangeNotifierProvider(
  create: (context) => ThemeProvider())],

    child: PontoCertoTaxi(),

)

  );
}

class PontoCertoTaxi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ponto Certo - Táxi',
          theme: themeProvider.currentTheme,
          home: TelaInicio(),
        );
      },
    );
  }
}