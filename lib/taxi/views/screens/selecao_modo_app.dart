import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/controllers/modo_app_controller.dart';
import 'package:ponto_taxi_df/taxi/models/constants/versao_app.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import 'home/tela_inicio.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});
  static const String numero = VersaoApp.numero;

  @override
  Widget build(BuildContext context) {
    final modoApp = context.read<ModoAppController>();
    final themeProvider = context.watch<ThemeProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: isDesktop
            ? _buildDesktopLayout(context, modoApp, themeProvider, screenWidth, screenHeight)
            : isTablet
            ? _buildTabletLayout(context, modoApp, themeProvider, screenWidth, screenHeight)
            : _buildMobileLayout(context, modoApp, themeProvider),
      ),
    );
  }

  // ========================= DESKTOP (> 1024px) =========================
  Widget _buildDesktopLayout(BuildContext context, ModoAppController modoApp,
      ThemeProvider themeProvider, double screenWidth, double screenHeight) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.35,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? const Color(0xFF2A2A2A)
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDesktopHeader(themeProvider),
              const SizedBox(height: 40),
              _buildFooter(themeProvider),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildDesktopCard(
                      context: context,
                      themeProvider: themeProvider,
                      title: 'Modo Vistoria',
                      subtitle: 'Realize vistorias de forma prática e eficiente',
                      icon: Icons.assignment_turned_in_rounded,
                      color: const Color(0xFF27AE60),
                      onTap: () {
                        modoApp.selecionarModoVistoria();
                        themeProvider.setModoApp(ModoApp.vistoria);
                        _navigateToHome(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildDesktopCard(
                      context: context,
                      themeProvider: themeProvider,
                      title: 'Modo Cadastro',
                      subtitle: 'Gerencie cadastros de forma rápida e segura',
                      icon: Icons.add_home,
                      color: const Color(0xFF4A90E2),
                      onTap: () {
                        modoApp.selecionarModoCadastro();
                        themeProvider.setModoApp(ModoApp.cadastro);
                        _navigateToHome(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========================= TABLET (768px - 1024px) =========================
  Widget _buildTabletLayout(BuildContext context, ModoAppController modoApp,
      ThemeProvider themeProvider, double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 32),
        child: Column(
          children: [
            _buildHeader(themeProvider),
            const SizedBox(height: 60),
            Row(
              children: [
                Expanded(
                  child: _buildTabletCard(
                    context: context,
                    themeProvider: themeProvider,
                    title: 'Modo Vistoria',
                    subtitle: 'Realize vistorias de forma prática e eficiente',
                    icon: Icons.assignment_turned_in_rounded,
                    color: const Color(0xFF27AE60),
                    onTap: () {
                      modoApp.selecionarModoVistoria();
                      themeProvider.setModoApp(ModoApp.vistoria);
                      _navigateToHome(context);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTabletCard(
                    context: context,
                    themeProvider: themeProvider,
                    title: 'Modo Cadastro',
                    subtitle: 'Gerencie cadastros de forma rápida e segura',
                    icon: Icons.add_home,
                    color: const Color(0xFF4A90E2),
                    onTap: () {
                      modoApp.selecionarModoCadastro();
                      themeProvider.setModoApp(ModoApp.cadastro);
                      _navigateToHome(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            _buildFooter(themeProvider),
          ],
        ),
      ),
    );
  }

  // ========================= MOBILE (< 768px) =========================
  Widget _buildMobileLayout(BuildContext context, ModoAppController modoApp,
      ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeader(themeProvider),
            const SizedBox(height: 65),
            Column(
              children: [
                _buildSelectionCard(
                  context: context,
                  themeProvider: themeProvider,
                  title: 'Modo Vistoria',
                  subtitle: 'Realize vistorias de forma prática e eficiente',
                  icon: Icons.assignment_turned_in_rounded,
                  color: const Color(0xFF27AE60),
                  onTap: () {
                    modoApp.selecionarModoVistoria();
                    themeProvider.setModoApp(ModoApp.vistoria);
                    _navigateToHome(context);
                  },
                ),
                const SizedBox(height: 24),
                _buildSelectionCard(
                  context: context,
                  themeProvider: themeProvider,
                  title: 'Modo Cadastro',
                  subtitle: 'Gerencie cadastros de forma rápida e segura',
                  icon: Icons.add_home,
                  color: const Color(0xFF4A90E2),
                  onTap: () {
                    modoApp.selecionarModoCadastro();
                    themeProvider.setModoApp(ModoApp.cadastro);
                    _navigateToHome(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildFooter(themeProvider),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ========================= HEADERS =========================
  Widget _buildDesktopHeader(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: themeProvider.primaryColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: themeProvider.primaryColor.withValues(alpha: 0.3),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: const Icon(Icons.apps_rounded, color: Colors.white, size: 50),
        ),
        const SizedBox(height: 32),
        Text(
          'Selecione a\nFunção',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Escolha entre as opções disponíveis\npara continuar',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: themeProvider.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeProvider.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.apps_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 24),
        Text(
          'Selecione a Função',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Escolha entre as opções disponíveis',
          style: TextStyle(
            fontSize: 16,
            color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }

  // ========================= CARDS =========================
  Widget _buildDesktopCard({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 320,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF7F8C8D),
                height: 1.4,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletCard({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 250,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 35),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF7F8C8D),
                height: 1.4,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF7F8C8D),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================= FOOTER =========================
  Widget _buildFooter(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: themeProvider.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Versão $numero',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white54 : const Color(0xFF95A5A6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TelaInicioPage()),
    );
  }
}
