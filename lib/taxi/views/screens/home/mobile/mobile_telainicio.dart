import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../../../../providers/themes/tema_provider.dart';
import '../../../widgets/sub_menu.dart';
import '../../../../controllers/tela_inicio_controller.dart';
import '../../../../models/constants/app_constants.dart';
import '../../registros.dart';
import '../../mapa_inicio.dart';
import '../../menu.dart';

class MobileTelaInicio extends StatefulWidget {
  const MobileTelaInicio({super.key});

  @override
  State<MobileTelaInicio> createState() => _MobileTelaInicioState();
}

class _MobileTelaInicioState extends State<MobileTelaInicio> {
  final controller = TelaInicioController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            Registros(),
            MapaCadastrar(),
            Menu(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: CurvedNavigationBar(
            color: themeProvider.primaryColor,
            animationDuration: AppConstants.navigationAnimationDuration,
            backgroundColor: Colors.transparent,
            height: AppConstants.navigationBarAltura,
            index: controller.pageIndex,
            items: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: AppConstants.iconSize,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey[100],
              ),
              Icon(
                Icons.map,
                size: AppConstants.iconSize,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey[100],
              ),
              Icon(
                Icons.menu,
                size: AppConstants.iconSize,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey[100],
              ),
            ],
            onTap: (index) => controller.onNavTap(index, () => setState(() {})),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: controller.pageIndex == 1
            ? const SubMenu()
            : null,
      ),
    );
  }
}