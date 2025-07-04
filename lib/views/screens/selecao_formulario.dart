import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import 'formulario_taxi.dart';
import 'formulario_stip.dart';

class SelecaoForm extends StatelessWidget {
  final List<Marker> pontos;

  const SelecaoForm({super.key, required this.pontos});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 8,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: 60),
              // Header
              _buildHeader(themeProvider),

              const SizedBox(height: 60),

              // Cards de Seleção
              Expanded(
                child: Column(
                  children: [
                    _buildSelectionCard(
                      context: context,
                      themeProvider: themeProvider,
                      title: 'Formulário STIP',
                      subtitle: 'Preencha os dados para o STIP',
                      icon: Icons.directions_car,
                      color: themeProvider.primaryColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormularioSTIP(pontos: pontos),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildSelectionCard(
                      context: context,
                      themeProvider: themeProvider,
                      title: 'Formulário Taxi',
                      subtitle: 'Preencha os dados para o taxi',
                      icon: Icons.local_taxi,
                      color: const Color(0xFFEFD31C),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormularioTaxi(pontos: pontos),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Footer
              _buildFooter(themeProvider),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
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
          'Versão 1.0.0',
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
}