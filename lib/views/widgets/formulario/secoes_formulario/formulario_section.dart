import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/themes/tema_provider.dart';
import 'custom_text_field.dart';
import 'formulario_header.dart';

class FormularioSection extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final TextEditingController vagasController;
  final TextEditingController telefoneController;

  final bool pontoOficial;
  final bool temSinalizacao;
  final String classificacaoEstrutura;
  final String autorizatario;
  final bool   isLoadingEndereco;

  final Function(bool) onPontoOficialChanged;
  final Function(bool) onTemSinalizacaoChanged;
  final Function(String?) onClassificacaoChanged;
  final Function(String?) onAutorizatarioChanged;
  final VoidCallback onImagemSelecionada;

   FormularioSection({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.vagasController,
    required this.telefoneController,
    required this.pontoOficial,
    required this.temSinalizacao,
    required this.classificacaoEstrutura,
    required this.autorizatario,
    required this.onPontoOficialChanged,
    required this.onTemSinalizacaoChanged,
    required this.onClassificacaoChanged,
    required this.onAutorizatarioChanged,
    required this.onImagemSelecionada,
      required this.isLoadingEndereco,
  });


  // Lista simulada de autorizatários
  final List<String> autorizatarios = [
    'Alessandra Silva - REG001',
    'Maria Santos - REG002',
    'Pedro Oliveira - REG003',
    'Ana Costa - REG004',
    'Carlos Ferreira - REG005',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();


    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? const Color(0xFF252525)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormularioHeader(),
          const SizedBox(height: 20),

          // ➜ Endereço + indicador de carregamento
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: enderecoController,
                  label     : 'Endereço',
                  icon      : Icons.location_on_outlined,
                  hint      : isLoadingEndereco
                      ? 'Buscando endereço...'
                      : 'Ex: Asa Norte SQN 410 - Asa Norte',
                  maxLines: 2,
                ),
              ),
              if (isLoadingEndereco) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 8),
          Text('Ponto Oficial', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Sim'),
                  value: pontoOficial == true,
                  onChanged: (val) {
                    if (val == true) onPontoOficialChanged(true);
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Não'),
                  value: pontoOficial == false,
                  onChanged: (val) {
                    if (val == true) onPontoOficialChanged(false);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text('Há Sinalização', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Sim'),
                  value: temSinalizacao == true,
                  onChanged: (val) {
                    if (val == true) onTemSinalizacaoChanged(true);
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Não'),
                  value: temSinalizacao == false,
                  onChanged: (val) {
                    if (val == true) onTemSinalizacaoChanged(false);
                  },
                ),
              ),
            ],
          ),


          CustomTextField(
            controller: vagasController,
            label: 'Nº de Vagas',
            icon: Icons.directions_car_filled,
            keyboardType: TextInputType.number,
            hint: 'ex: 4',
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: classificacaoEstrutura,
            decoration: const InputDecoration(
              labelText: 'Classificação da Estrutura',
              prefixIcon: Icon(Icons.home_work),
            ),
            items: ['Coberto', 'Descoberto', 'Parcial']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onClassificacaoChanged,
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: telefoneController,
            label: 'Telefone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            hint: 'ex: (61) 3321-8181',
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: autorizatario.isNotEmpty ? autorizatario : null,
            decoration: const InputDecoration(
              labelText: 'Autorizatário',
              prefixIcon: Icon(Icons.person_search),
            ),
            items: autorizatarios.map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              );
            }).toList(),
            onChanged: onAutorizatarioChanged,
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: onImagemSelecionada,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Selecionar Imagem'),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.primaryColor,
            ),
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: observacoesController,
            label: 'Observações',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada. Há 06 vagas na saída.',
            maxLines: 3,
          ),

          const SizedBox(height: 16),

        ],
      ),
    );
  }
}
