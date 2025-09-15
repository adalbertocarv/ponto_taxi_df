import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../models/constants/versao_app.dart';
import '../../providers/themes/tema_provider.dart';
import 'formulario_taxi.dart';
import 'formulario_stip.dart';

class SelecaoForm extends StatelessWidget {
  final List<Marker> pontos;
  static const String numero = VersaoApp.numero;

  const SelecaoForm({super.key, required this.pontos});

  @override
  Widget build(BuildContext context) {
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
        child: isDesktop ? _buildDesktopLayout(context, themeProvider, screenWidth, screenHeight)
            : isTablet ? _buildTabletLayout(context, themeProvider, screenWidth, screenHeight)
            : _buildMobileLayout(context, themeProvider, screenWidth, screenHeight),
      ),
    );
  }

  // Layout Desktop (> 1024px)
  Widget _buildDesktopLayout(BuildContext context, ThemeProvider themeProvider, double screenWidth, double screenHeight) {
    return Row(
      children: [
        // Sidebar com informações
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
          child: Row(
            children: [
              _buildBackButton(context),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  _buildDesktopHeader(themeProvider),
                  const SizedBox(height: 40),
                  _buildFooter(themeProvider),
                ],
              ),
            ],
          ),
        ),
        // Área principal com os cards
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDesktopCard(
                            context: context,
                            themeProvider: themeProvider,
                            title: 'Formulário STIP',
                            subtitle: 'Preencha os dados para o STIP',
                            icon: Icons.directions_car,
                            color: themeProvider.primaryColor,
                            onTap: () => _navigateToSTIP(context),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _buildDesktopCard(
                            context: context,
                            themeProvider: themeProvider,
                            title: 'Formulário Taxi',
                            subtitle: 'Preencha os dados para o taxi',
                            icon: Icons.local_taxi,
                            color: const Color(0xFFEFD31C),
                            onTap: () => _navigateToTaxi(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Layout Tablet (768px - 1024px)
  Widget _buildTabletLayout(BuildContext context, ThemeProvider themeProvider, double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 32),
        child: Column(
          children: [
            _buildBackButton(context),
            const SizedBox(height: 40),
            _buildHeader(themeProvider),
            const SizedBox(height: 60),
            Row(
              children: [
                Expanded(
                  child: _buildTabletCard(
                    context: context,
                    themeProvider: themeProvider,
                    title: 'Formulário STIP',
                    subtitle: 'Preencha os dados para o STIP',
                    icon: Icons.directions_car,
                    color: themeProvider.primaryColor,
                    onTap: () => _navigateToSTIP(context),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTabletCard(
                    context: context,
                    themeProvider: themeProvider,
                    title: 'Formulário Taxi',
                    subtitle: 'Preencha os dados para o taxi',
                    icon: Icons.local_taxi,
                    color: const Color(0xFFEFD31C),
                    onTap: () => _navigateToTaxi(context),
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

  // Layout Mobile (< 768px)
  Widget _buildMobileLayout(BuildContext context, ThemeProvider themeProvider, double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildBackButton(context),
            const SizedBox(height: 60),
            _buildHeader(themeProvider),
            const SizedBox(height: 65),
            Column(
              children: [
                _buildSelectionCard(
                  context: context,
                  themeProvider: themeProvider,
                  title: 'Formulário STIP',
                  subtitle: 'Preencha os dados para o STIP',
                  icon: Icons.directions_car,
                  color: themeProvider.primaryColor,
                  onTap: () => _navigateToSTIP(context),
                ),
                const SizedBox(height: 24),
                _buildSelectionCard(
                  context: context,
                  themeProvider: themeProvider,
                  title: 'Formulário Taxi',
                  subtitle: 'Preencha os dados para o taxi',
                  icon: Icons.local_taxi,
                  color: const Color(0xFFEFD31C),
                  onTap: () => _navigateToTaxi(context),
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

  Widget _buildBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
    );
  }

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
          child: const Icon(
            Icons.document_scanner,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Selecione o\nFormulário',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: themeProvider.isDarkMode
                ? Colors.white
                : const Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Escolha entre as opções\ndisponíveis para continuar\ncom o preenchimento',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: themeProvider.isDarkMode
                ? Colors.white70
                : const Color(0xFF7F8C8D),
            fontWeight: FontWeight.w400,
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
          child: const Icon(
            Icons.document_scanner,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Selecione o Formulário',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode
                ? Colors.white
                : const Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Escolha entre as opções disponíveis',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: themeProvider.isDarkMode
                ? Colors.white70
                : const Color(0xFF7F8C8D),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopCard({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 320,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? const Color(0xFF2A2A2A)
                : Colors.white,
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
                child: Icon(
                  icon,
                  color: color,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.isDarkMode
                      ? Colors.white70
                      : const Color(0xFF7F8C8D),
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: color,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          color: themeProvider.isDarkMode
              ? const Color(0xFF2A2A2A)
              : Colors.white,
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
              child: Icon(
                icon,
                color: color,
                size: 35,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.isDarkMode
                    ? Colors.white70
                    : const Color(0xFF7F8C8D),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
            color: themeProvider.isDarkMode
                ? Colors.white54
                : const Color(0xFF95A5A6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
          color: themeProvider.isDarkMode
              ? const Color(0xFF2A2A2A)
              : Colors.white,
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
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.isDarkMode
                    ? Colors.white70
                    : const Color(0xFF7F8C8D),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSTIP(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => FormularioSTIP(pontos: pontos),
        builder: (context) => FormularioTaxi(pontos: pontos),
      ),
    );
  }

  void _navigateToTaxi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioTaxi(pontos: pontos),
      ),
    );
  }
}