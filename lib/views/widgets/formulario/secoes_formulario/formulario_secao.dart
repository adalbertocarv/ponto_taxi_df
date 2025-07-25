import 'dart:io';

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
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  final bool pontoOficial;
  final bool temSinalizacao;
  final bool temAbrigo;
  final bool temEnergia;
  final bool temAgua;

  final String classificacaoEstrutura;
  final String autorizatario;
  final String? imagemSelecionada;

  final bool isLoadingEndereco;

  final Function(bool) onPontoOficialChanged;
  final Function(bool) onTemSinalizacaoChanged;
  final Function(bool) onTemAbrigoChanged;
  final Function(bool) onTemEnergiaChanged;
  final Function(bool) onTemAguaChanged;
  final Function(String?) onClassificacaoChanged;
  final Function(String?) onAutorizatarioChanged;
  final VoidCallback onImagemSelecionada;

  FormularioSection({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.vagasController,
    required this.telefoneController,
    required this.latitudeController,
    required this.longitudeController,
    required this.pontoOficial,
    required this.temSinalizacao,
    required this.temAbrigo,
    required this.temEnergia,
    required this.temAgua,
    required this.classificacaoEstrutura,
    required this.autorizatario,
    required this.imagemSelecionada,
    required this.onPontoOficialChanged,
    required this.onTemSinalizacaoChanged,
    required this.onTemAbrigoChanged,
    required this.onTemEnergiaChanged,
    required this.onTemAguaChanged,
    required this.onClassificacaoChanged,
    required this.onAutorizatarioChanged,
    required this.onImagemSelecionada,
    required this.isLoadingEndereco,
  });

  final List<String> autorizatarios = [
    'Alessandra Silva - Num 001',
    'Maria Santos - Num 002',
    'Pedro Oliveira - Num 003',
    'Ana Costa - Num 004',
    'Carlos Ferreira - Num 005',
  ];

  Widget buildBooleanField({
    required String label,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required BuildContext context,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.isDarkMode
                  ? Colors.grey.shade700
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: themeProvider.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: value == true,
                          onChanged: (val) {
                            if (val == true) onChanged(true);
                          },
                          activeColor: themeProvider.primaryColor,
                        ),
                        Text(
                          'Sim',
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 48),
                    Row(
                      children: [
                        Checkbox(
                          value: value == false,
                          onChanged: (val) {
                            if (val == true) onChanged(false);
                          },
                          activeColor: themeProvider.primaryColor,
                        ),
                        Text(
                          'Não',
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormularioHeader(),
          const SizedBox(height: 20),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: enderecoController,
                  label: 'Endereço',
                  icon: Icons.location_on_outlined,
                  hint: isLoadingEndereco
                      ? 'Buscando endereço...'
                      : 'Ex: Asa Norte SQN 410',
                  maxLines: 2,
                ),
              ),
              if (isLoadingEndereco) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      themeProvider.primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          buildBooleanField(
            label: 'Ponto Oficial',
            icon: Icons.location_on,
            value: pontoOficial,
            onChanged: onPontoOficialChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Há Sinalização',
            icon: Icons.signpost,
            value: temSinalizacao,
            onChanged: onTemSinalizacaoChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem Abrigo',
            icon: Icons.home_filled,
            value: temAbrigo,
            onChanged: onTemAbrigoChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem Energia',
            icon: Icons.bolt,
            value: temEnergia,
            onChanged: onTemEnergiaChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem Água',
            icon: Icons.water_drop,
            value: temAgua,
            onChanged: onTemAguaChanged,
            context: context,
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
            value: ['Edificado', 'Não Edificado', 'Edificado Padrão Oscar Niemeyer'].contains(classificacaoEstrutura)
                ? classificacaoEstrutura
                : null,
            decoration: InputDecoration(
              labelText: 'Tipo do Abrigo',
              prefixIcon: Icon(
                Icons.home_filled,
                color: themeProvider.primaryColor,
              ),
              labelStyle: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: themeProvider.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: themeProvider.primaryColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.cardTheme.color,
            ),
            dropdownColor: theme.cardTheme.color,
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            ),
            items: ['Edificado', 'Não Edificado', 'Edificado Padrão Oscar Niemeyer']
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ))
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
            decoration: InputDecoration(
              labelText: 'Autorizatário',
              prefixIcon: Icon(
                Icons.person_search,
                color: themeProvider.primaryColor,
              ),
              labelStyle: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: themeProvider.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: themeProvider.primaryColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.cardTheme.color,
            ),
            dropdownColor: theme.cardTheme.color,
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            ),
            items: autorizatarios.map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: onAutorizatarioChanged,
          ),

          const SizedBox(height: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: onImagemSelecionada,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Selecionar Imagem'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if ((imagemSelecionada?.isNotEmpty ?? false) &&
                  File(imagemSelecionada!).existsSync()) ...[
                Text(
                  'Imagem selecionada:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeProvider.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      File(imagemSelecionada!),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: observacoesController,
            label: 'Observações',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada.',
            maxLines: 3,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}