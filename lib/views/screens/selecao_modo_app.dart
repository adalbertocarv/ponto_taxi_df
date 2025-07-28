import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/controllers/modo_app_controller.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import 'telainicio.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modoApp = context.read<ModoAppController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Header
              _buildHeader(),

              const SizedBox(height: 65),

              // Cards de Seleção
              Expanded(
                child: Column(
                  children: [
                    _buildSelectionCard(
                      context: context,
                      title: 'Modo Vistoria',
                      subtitle: 'Realize vistorias de forma prática e eficiente',
                      icon: Icons.assignment_turned_in_rounded,
                      color: const Color(0xFF27AE60),
                      onTap: () {
                        modoApp.selecionarModoVistoria();
                        context.read<ThemeProvider>().setModoApp(ModoApp.vistoria);
                        _navigateToHome(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildSelectionCard(
                      context: context,
                      title: 'Modo Cadastro',
                      subtitle: 'Gerencie cadastros de forma rápida e segura',
                      icon: Icons.add_home,
                      color: const Color(0xFF4A90E2),
                      onTap: () {
                        modoApp.selecionarModoCadastro();
                        context.read<ThemeProvider>().setModoApp(ModoApp.cadastro);
                        _navigateToHome(context);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Footer
              _buildFooter(),
              const SizedBox(height: 8,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.apps_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Selecione a Função',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Escolha entre as opções disponíveis',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7F8C8D),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Versão 1.0.0',
          style: TextStyle(
            color: Color(0xFF95A5A6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.08),
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
                    color: color.withValues(alpha:0.1),
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
                    color: color.withValues(alpha:0.1),
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
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TelaInicio(),
      ),
    );
  }
}
