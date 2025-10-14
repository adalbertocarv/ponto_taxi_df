import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/themes/tema_provider.dart';
import '../../../../controllers/tela_inicio_controller.dart';
import '../../../widgets/confirmacao_modo_app.dart';
import '../../registros.dart';
import '../../mapa_inicio.dart';
import '../../menu.dart';
import '../../../../controllers/modo_app_controller.dart';

class DesktopTelaInicio extends StatefulWidget {
  const DesktopTelaInicio({super.key});

  @override
  State<DesktopTelaInicio> createState() => _DesktopTelaInicioState();
}

class _DesktopTelaInicioState extends State<DesktopTelaInicio> {
  late final TelaInicioController controller;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    controller = TelaInicioController(isDesktop: true, pageIndex: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final modoApp = context.watch<ModoAppController>();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isCollapsed ? 80 : 320,
            child: Container(
              decoration: BoxDecoration(
                //color: themeProvider.primaryColor,
                color: themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header da Sidebar
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (!_isCollapsed) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'SEMOB',
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    //color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Ponto Certo - Táxi',
                                  style: TextStyle(
                                    //color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
                                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 90,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Image.asset('assets/images/gdf.png', fit: BoxFit.cover,),
                          )
                        ],
                        IconButton(
                          onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
                          icon: Icon(
                            _isCollapsed ? Icons.menu : Icons.menu_open,
                            //color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: Colors.white24, height: 1),

                  // Indicador do Modo Atual
                  if (!_isCollapsed)
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmacaoDialog(
                                modoApp: modoApp,
                                themeProvider: themeProvider,
                              );
                            });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (modoApp.isCadastro ? Colors.lightBlueAccent : Colors.greenAccent).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: modoApp.isCadastro ? Colors.lightBlueAccent : Colors.greenAccent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              modoApp.isCadastro ? Icons.add_home : Icons.assignment_turned_in_rounded,
                              color: modoApp.isCadastro ? Colors.lightBlueAccent : Colors.greenAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Modo ${modoApp.isCadastro ? 'Cadastro' : 'Vistoria'}',
                                style: TextStyle(
                                  //color: Colors.white,
                                  color: modoApp.isCadastro ? Colors.blue : Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Navigation Items
                  Expanded(
                    child: ListView(
                      children: [
                        _buildNavItem(
                          icon: Icons.add_circle_outline_rounded,
                          label: 'Registros',
                          index: 0,
                          isSelected: controller.pageIndex == 0,
                          themeProvider: themeProvider,
                        ),
                        _buildNavItem(
                          icon: Icons.map,
                          label: 'Mapa',
                          index: 1,
                          isSelected: controller.pageIndex == 1,
                          themeProvider: themeProvider,
                        ),
                        _buildNavItem(
                          icon: Icons.info,
                          label: 'Menu',
                          index: 2,
                          isSelected: controller.pageIndex == 2,
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ),

                  // Footer da Sidebar
                  if (!_isCollapsed)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Divider(color: Colors.grey[400]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text('SUBSECRETARIA DE TECNOLOGIA \nDA INFORMAÇÃO – SUTINF',
                            style: TextStyle(
                              color: Colors.grey[900],
                                      fontSize: 12,
                                    ),
                            ),
                            Icon(Icons.computer)
                          ],)
                          // Row(
                          //   children: [
                          //     Icon(
                          //       themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          //       color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
                          //       size: 20,
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Text(
                          //       themeProvider.isDarkMode ? 'Tema Escuro' : 'Tema Claro',
                          //       style: TextStyle(
                          //         color: themeProvider.isDarkMode ? Colors.white : Colors.grey[100],
                          //         fontSize: 12,
                          //       ),
                          //     ),
                          //     const Spacer(),
                          //     Switch(
                          //       value: themeProvider.isDarkMode,
                          //       onChanged: (value) => themeProvider.toggleTheme(),
                          //       activeColor: Colors.white,
                          //       activeTrackColor: Colors.white24,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Page Content
                Expanded(
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: controller.pageIndex,
                        children: const [
                          DesktopRegistrosWrapper(),
                          DesktopMapaWrapper(),
                          DesktopMenuWrapper(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => controller.onNavTap(index, () => setState(() {})),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  // color: isSelected
                  //     ? Colors.white
                  //     : (themeProvider.isDarkMode ? Colors.white : Colors.grey[100])?.withValues(alpha: 0.7),
                  color: themeProvider.isDarkMode ? Colors.white : Colors.grey[500],
                  size: 24,
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        // color: isSelected
                        //     // ? Colors.white
                        //     // : (themeProvider.isDarkMode ? Colors.white : Colors.grey[100])?.withValues(alpha: 0.7),
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                if (isSelected && !_isCollapsed)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (controller.pageIndex) {
      case 0:
        return 'Registros';
      case 1:
        return 'Mapa';
      case 2:
        return 'Menu';
      default:
        return 'Ponto Certo Taxi DF';
    }
  }
}

// Wrappers para adaptar as telas móveis ao desktop
class DesktopRegistrosWrapper extends StatelessWidget {
  const DesktopRegistrosWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Registros(),
    );
  }
}

class DesktopMapaWrapper extends StatelessWidget {
  const DesktopMapaWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapaCadastrar();
  }
}

class DesktopMenuWrapper extends StatelessWidget {
  const DesktopMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Menu(),
    );
  }
}