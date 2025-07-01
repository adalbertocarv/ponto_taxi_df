import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/themes/tema_provider.dart';
import '/views/widgets/sub_menu.dart';
import '../../controllers/tela_inicio_controller.dart';
import 'registros.dart';
import 'mapa_cadastrar.dart';
import 'menu.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  final controller = TelaInicioController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
           Registros(),
           MapaCadastrar(),
          Menu(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: themeProvider.primaryColor,
          animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        index: controller.pageIndex,
        items: [
          Icon(
            Icons.add_circle_outline_rounded,
            size: 30,
            color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
          ),
          Icon(
            Icons.map,
            size: 30,
            color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
          ),
          Icon(
            Icons.menu,
            size: 30,
            color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
          ),
        ],
        onTap: (index) => controller.onNavTap(index, () => setState(() {})),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: controller.pageIndex == 1
          ? SubMenu()
          : null,
    );
  }
}