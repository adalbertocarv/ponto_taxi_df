import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/themes/tema_provider.dart';

class BotoesAcaoSecao extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final TextEditingController vagasController;
  final VoidCallback onSalvar;

  const BotoesAcaoSecao({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.vagasController,
    required this.onSalvar,
  });

  // Função para determinar se é desktop
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  // Validação básica dos campos obrigatórios
  bool _isFormValid() {
    return enderecoController.text.trim().isNotEmpty;
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header da seção
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.save_rounded,
                  color: Color(0xFFE74C3C),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Finalizar Cadastro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Botões em linha para desktop
          Row(
            children: [
              // Botão Cancelar
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: themeProvider.isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                    foregroundColor: themeProvider.isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Botão Limpar
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLimparDialog(context);
                  },
                  icon: const Icon(Icons.cleaning_services_rounded),
                  label: const Text('Limpar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Colors.orange.shade400,
                      width: 1.5,
                    ),
                    foregroundColor: Colors.orange.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Botão Salvar (maior)
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: _isFormValid() ? onSalvar : null,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Salvar Ponto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid()
                        ? const Color(0xFF27AE60)
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: _isFormValid() ? 2 : 0,
                    shadowColor: const Color(0xFF27AE60).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Informação de validação
          if (!_isFormValid()) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Preencha o endereço para continuar',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header da seção
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.save_rounded,
                  color: Color(0xFFE74C3C),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Finalizar Cadastro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botão Salvar (principal)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isFormValid() ? onSalvar : null,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Salvar Ponto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid()
                    ? const Color(0xFF27AE60)
                    : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: _isFormValid() ? 2 : 0,
                shadowColor: const Color(0xFF27AE60).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Botões secundários em linha
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: themeProvider.isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                    foregroundColor: themeProvider.isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLimparDialog(context);
                  },
                  icon: const Icon(Icons.cleaning_services_rounded, size: 18),
                  label: const Text('Limpar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: Colors.orange.shade400,
                      width: 1.5,
                    ),
                    foregroundColor: Colors.orange.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Informação de validação
          if (!_isFormValid()) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Preencha o endereço para continuar',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLimparDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Confirmar Limpeza'),
            ],
          ),
          content: const Text(
            'Tem certeza que deseja limpar todos os campos? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                enderecoController.clear();
                observacoesController.clear();
                vagasController.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isDesktop(context)
        ? _buildDesktopLayout(context)
        : _buildMobileLayout(context);
  }
}