import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../../../../providers/themes/tema_provider.dart';

class BotoesAcaoSecao2 extends StatelessWidget {
  // --- Text Controllers ---
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final TextEditingController observacoesAvController;
  final TextEditingController vagasController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  // --- Outros Campos do Formulário ---
  final String classificacaoEstrutura;
  final double valorNota;
  final String? imagemSelecionada; // Apenas o nome ou caminho para revisão

  // --- Campos Booleanos STIP (TODOS para revisão) ---
  final bool temSanitariosMascFem;
  final bool temChuveirosIndividuais;
  final bool temVestuarios;
  final bool temSalaDescanso;
  final bool temWifi;
  final bool temPontosCarregarCelular;
  final bool temEspacoRefeicao;
  final bool temEspacoEstacionarBike;
  final bool temPontoEspera;
  final bool empresaGaranteManutencao;

  // --- Callbacks e Ações ---
  final VoidCallback onSalvar;
  final VoidCallback onLimpar;
  final bool isLoading;

  const BotoesAcaoSecao2({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.observacoesAvController,
    required this.vagasController,
    required this.latitudeController,
    required this.longitudeController,
    required this.classificacaoEstrutura,
    required this.valorNota,
    required this.imagemSelecionada,
    required this.temSanitariosMascFem,
    required this.temChuveirosIndividuais,
    required this.temVestuarios,
    required this.temSalaDescanso,
    required this.temWifi,
    required this.temPontosCarregarCelular,
    required this.temEspacoRefeicao,
    required this.temEspacoEstacionarBike,
    required this.temPontoEspera,
    required this.empresaGaranteManutencao,
    required this.onSalvar,
    required this.onLimpar,
    required this.isLoading,
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
            child: Text(value.trim().isNotEmpty ? value : 'Não informado'),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para formatar booleanos
  String _formatBoolean(bool value) => value ? 'Sim' : 'Não';

  // Validação básica (usando Endereço como campo obrigatório)
  bool _isFormValid() {
    return enderecoController.text.trim().isNotEmpty;
  }

  // 💡 FUNÇÃO: Exibe o Diálogo de Confirmação com Revisão de TODOS os Dados
  void _showConfirmacaoDialog(BuildContext context) {
    final formValido = _isFormValid();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação de Dados STIP'),
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

                // --- Seção de Dados Principais ---
                _buildReviewRow('Endereço', enderecoController.text),
                _buildReviewRow('Classificação', classificacaoEstrutura),
                _buildReviewRow('Nº de Vagas', vagasController.text),
                _buildReviewRow('Latitude', latitudeController.text),
                _buildReviewRow('Longitude', longitudeController.text),
                _buildReviewRow(
                    'Imagem (Nome)', imagemSelecionada ?? 'Nenhuma'),

                const Divider(),

                // --- Seção de Avaliação ---
                _buildReviewRow(
                    'Nota de Avaliação (1-5)', valorNota.toStringAsFixed(0)),
                _buildReviewRow(
                    'Obs. da Avaliação', observacoesAvController.text),
                _buildReviewRow('Obs. Gerais', observacoesController.text),

                const Divider(),

                // --- Seção de Infraestrutura (Booleanos) ---
                const Text(
                  'Infraestrutura (Recursos do Ponto):',
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
                ),
                const SizedBox(height: 8),

                _buildReviewRow('Sanitários Masc/Fem',
                    _formatBoolean(temSanitariosMascFem)),
                _buildReviewRow('Chuveiros Individuais',
                    _formatBoolean(temChuveirosIndividuais)),
                _buildReviewRow('Vestuários', _formatBoolean(temVestuarios)),
                _buildReviewRow(
                    'Sala de Descanso', _formatBoolean(temSalaDescanso)),
                _buildReviewRow('Wi-Fi', _formatBoolean(temWifi)),
                _buildReviewRow('Pontos Carregar Celular',
                    _formatBoolean(temPontosCarregarCelular)),
                _buildReviewRow(
                    'Espaço Refeição', _formatBoolean(temEspacoRefeicao)),
                _buildReviewRow('Espaço Estacionar Bike',
                    _formatBoolean(temEspacoEstacionarBike)),
                _buildReviewRow(
                    'Ponto de Espera', _formatBoolean(temPontoEspera)),
                _buildReviewRow('Empresa Garante Manutenção',
                    _formatBoolean(empresaGaranteManutencao)),

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

  // --- Métodos de Layout (Desktop/Mobile) ---

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    // ... (Implementação de Layout - Usando o layout anterior como base) ...
    // Estou simplificando a implementação do build para focar na lógica de ação.

    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final formValido = _isFormValid();

    Widget buildButtonSet() {
      final isDesktop = _isDesktop(context);

      if (!isDesktop) {
        // ======== MOBILE (< 900px) ========
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botão Salvar em cima
            ElevatedButton.icon(
              onPressed: formValido && !isLoading
                  ? () => _showConfirmacaoDialog(context)
                  : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(isLoading ? 'Salvando...' : 'Salvar Ponto STIP'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    formValido ? const Color(0xFF27AE60) : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                elevation: formValido ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Linha com Cancelar e Limpar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Cancelar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 25),
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
                    onPressed: onLimpar,
                    icon: const Icon(Icons.cleaning_services_rounded, size: 20),
                    label: const Text('Limpar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 25),
                      foregroundColor: Colors.orange.shade600,
                      side:
                          BorderSide(color: Colors.orange.shade400, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }

      // ======== DESKTOP (>= 900px) ========
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
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
          SizedBox(width: isDesktop ? 16 : 20),
          OutlinedButton.icon(
            onPressed: onLimpar,
            icon: const Icon(Icons.cleaning_services_rounded, size: 20),
            label: const Text('Limpar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
              foregroundColor: Colors.orange.shade600,
              side: BorderSide(color: Colors.orange.shade400, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(width: isDesktop ? 16 : 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: formValido && !isLoading
                  ? () => _showConfirmacaoDialog(context)
                  : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(isLoading ? 'Salvando...' : 'Salvar Ponto STIP'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    formValido ? const Color(0xFF27AE60) : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                elevation: formValido ? 2 : 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: _isDesktop(context) ? null : const EdgeInsets.only(top: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações Finais',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          buildButtonSet(),
          if (!formValido) ...[
            const SizedBox(height: 12),
            // Mensagem de validação
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'O campo Endereço é obrigatório para salvar.',
                      style:
                          TextStyle(color: Colors.red.shade800, fontSize: 14),
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
}
