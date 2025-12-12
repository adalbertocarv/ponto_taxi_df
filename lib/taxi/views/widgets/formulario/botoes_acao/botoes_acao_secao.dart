import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/themes/tema_provider.dart';

class BotoesAcaoSecao extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController; // Observações Gerais
  final TextEditingController vagasController;

  // NOVOS CAMPOS ADICIONADOS PARA REVISÃO:
  final String autorizatarioSelecionado;
  final String classificacaoEstrutura;
  final TextEditingController telefoneController;
  final TextEditingController
      observacoesAvController; // Observações da Avaliação
  final bool pontoOficial;
  final bool temSinalizacao;
  final bool temAbrigo;
  final bool temEnergia;
  final bool temAgua;
  // Fim dos novos campos

  final VoidCallback onSalvar;
  final bool isLoading;

  const BotoesAcaoSecao({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.vagasController,
    required this.onSalvar,
    required this.isLoading,

    // Inicializando os NOVOS CAMPOS
    required this.autorizatarioSelecionado,
    required this.classificacaoEstrutura,
    required this.telefoneController,
    required this.observacoesAvController,
    required this.pontoOficial,
    required this.temSinalizacao,
    required this.temAbrigo,
    required this.temEnergia,
    required this.temAgua,
  });

  // Função auxiliar para construir uma linha de dado para revisão
  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para formatar booleanos
  String _formatBoolean(bool value) => value ? 'Sim' : 'Não';

  // Função para determinar se é desktop
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  // Validação básica dos campos obrigatórios
  bool _isFormValid() {
    return enderecoController.text.trim().isNotEmpty;
  }

  // 💡 FUNÇÃO: Exibe o Diálogo de Confirmação com Revisão de TODOS os Dados
  void _showConfirmacaoDialog(
    BuildContext context, {
    required String autorizatario,
    required String classificacao,
    required String vagas,
    required String telefone,
    required bool pOficial,
    required bool temSinal,
    required bool temAbr,
    required bool temEnerg,
    required bool temAgua,
    required String obsAv,
    required String obsGeral,
    required bool formValido,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação de Dados'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '⚠️ Por favor, revise os dados a seguir antes de confirmar o salvamento.',
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.w600),
                ),
                const Divider(),

                // --- Dados do Formulário Principal (Revisão) ---

                // 1. Endereço (Campo do Controller que você já tinha)
                _buildReviewRow(
                    'Endereço',
                    enderecoController.text.isNotEmpty
                        ? enderecoController.text
                        : 'Não informado'),

                // 2. Autorizatário
                _buildReviewRow('Autorizatário',
                    autorizatario.isNotEmpty ? autorizatario : 'Não informado'),

                // 3. Classificação/Infraestrutura
                _buildReviewRow('Classificação',
                    classificacao.isNotEmpty ? classificacao : 'Não informado'),

                const Divider(),

                // 4. Vagas e Telefone
                _buildReviewRow(
                    'Nº de Vagas', vagas.isNotEmpty ? vagas : 'Não informado'),
                _buildReviewRow('Telefone',
                    telefone.isNotEmpty ? telefone : 'Não informado'),

                const Divider(),

                const Text(
                  'Características:',
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
                ),

                // 5. Campos Booleanos
                _buildReviewRow('Ponto Oficial', _formatBoolean(pOficial)),
                _buildReviewRow('Há Sinalização', _formatBoolean(temSinal)),
                _buildReviewRow('Tem Abrigo', _formatBoolean(temAbr)),

                // Campos Condicionais (Energia/Água - só se 'Tem Abrigo' for true)
                if (temAbr) ...[
                  _buildReviewRow('Tem Energia', _formatBoolean(temEnerg)),
                  _buildReviewRow('Tem Água', _formatBoolean(temAgua)),
                ],

                const Divider(),

                // 6. Observações da Avaliação
                _buildReviewRow(
                    'Obs. da Avaliação', obsAv.isNotEmpty ? obsAv : 'Nenhuma'),

                // 7. Observações Gerais
                _buildReviewRow(
                    'Obs. Gerais', obsGeral.isNotEmpty ? obsGeral : 'Nenhuma'),

                const SizedBox(height: 16),
                const Text(
                  'Confirma a criação deste ponto com os dados acima?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Botão "Cancelar"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o popup
              },
              child: const Text('Cancelar'),
            ),

            // Botão "Salvar" (Ação principal do popup)
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: isLoading || !formValido
                    ? null
                    : onSalvar, // Chama a função de salvamento
                icon: const Icon(Icons.save_rounded),
                label: const Text('Confirmar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: formValido
                      ? const Color(0xFF27AE60)
                      : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  elevation: formValido ? 2 : 0,
                  shadowColor: const Color(0xFF27AE60).withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ... (Header da Seção - sem mudanças) ...
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withOpacity(0.1),
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

              // 💡 Botão Salvar (Atualizado para passar TODOS os dados para revisão)
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: _isFormValid()
                      ? () => _showConfirmacaoDialog(
                            context,
                            autorizatario: autorizatarioSelecionado,
                            classificacao: classificacaoEstrutura,
                            vagas: vagasController.text,
                            telefone: telefoneController.text,
                            pOficial: pontoOficial,
                            temSinal: temSinalizacao,
                            temAbr: temAbrigo,
                            temEnerg: temEnergia,
                            temAgua: temAgua,
                            obsAv: observacoesAvController.text,
                            obsGeral: observacoesController.text,
                            formValido: _isFormValid(),
                          )
                      : null,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Salvar Ponto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid()
                        ? const Color(0xFF27AE60)
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: _isFormValid() ? 2 : 0,
                    shadowColor: const Color(0xFF27AE60).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ... (Informação de validação - sem mudanças) ...
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
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ... (Header da Seção - sem mudanças) ...
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withOpacity(0.1),
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

          // 💡 Botão Salvar (principal) - Atualizado para passar TODOS os dados para revisão
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isFormValid()
                  ? () => _showConfirmacaoDialog(
                        context,
                        autorizatario: autorizatarioSelecionado,
                        classificacao: classificacaoEstrutura,
                        vagas: vagasController.text,
                        telefone: telefoneController.text,
                        pOficial: pontoOficial,
                        temSinal: temSinalizacao,
                        temAbr: temAbrigo,
                        temEnerg: temEnergia,
                        temAgua: temAgua,
                        obsAv: observacoesAvController.text,
                        obsGeral: observacoesController.text,
                        formValido: _isFormValid(),
                      )
                  : null,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Salvar Ponto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid()
                    ? const Color(0xFF27AE60)
                    : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: _isFormValid() ? 2 : 0,
                shadowColor: const Color(0xFF27AE60).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ... (Botões secundários e Informação de validação - sem mudanças) ...
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
    // ... (Função de limpar - sem mudanças) ...
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
