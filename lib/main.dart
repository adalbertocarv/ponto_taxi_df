import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/providers/autenticacao/auth_provider.dart';
import 'package:ponto_taxi_df/views/screens/login.dart';
import 'package:provider/provider.dart';

import 'controllers/mapa_controller.dart';
import 'controllers/perfil_controller.dart';
import 'providers/themes/tema_provider.dart';
import 'views/screens/telainicio.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapaController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PerfilController()),
      ],
      child: PontoCertoTaxi(),
    ),
  );
}

class PontoCertoTaxi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ponto Certo - Táxi',
              theme: themeProvider.currentTheme,
              home: authProvider.isAuthenticated ? TelaInicio() : LoginScreen(),
            );
          },
        );
      },
    );
  }
}
