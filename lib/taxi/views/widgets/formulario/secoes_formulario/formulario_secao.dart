import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/autorizatario.dart';
import '../../../../providers/themes/tema_provider.dart';
import '../../../../services/autorizatario_service.dart';
import 'custom_text_field.dart';
import 'formulario_header.dart';

class FormularioSection extends StatelessWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final TextEditingController vagasController;
  final TextEditingController telefoneController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final ValueNotifier<double> sliderValue = ValueNotifier(1);

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
    //required this.sliderValue,
  });

  final List<String> autorizatarios = [
    'Alessandra Silva - Num 001',
    'Maria Santos - Num 002',
    'Pedro Oliveira - Num 003',
    'Ana Costa - Num 004',
    'Carlos Ferreira - Num 005',
  ];

  // Função para determinar se é desktop/tablet
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

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
        const SizedBox(height: 8),
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
                    SizedBox(width: _isDesktop(context) ? 24 : 48),
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

  Widget _buildDesktopLayout(BuildContext context) {
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
          const SizedBox(height: 24),

          // Endereço com loading indicator
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
          const SizedBox(height: 20),

          // Row com campos de seleção (2 colunas)
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: [
                    'Edificado',
                    'Não Edificado',
                    'Edificado Padrão Oscar Niemeyer'
                  ].contains(classificacaoEstrutura)
                      ? classificacaoEstrutura
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Tipo do Abrigo',
                    prefixIcon: Icon(
                      Icons.home_filled,
                      color: themeProvider.primaryColor,
                    ),
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                  items: [
                    'Edificado',
                    'Não Edificado',
                    'Edificado Padrão Oscar Niemeyer'
                  ]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: onClassificacaoChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Autocomplete<Autorizatario>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Autorizatario>.empty();
                    }
                    try {
                      final results =
                          await AutorizatarioService.buscarAutorizatarios(
                              textEditingValue.text);
                      return results;
                    } catch (e) {
                      return const Iterable<Autorizatario>.empty();
                    }
                  },
                  displayStringForOption: (Autorizatario option) =>
                      option.toString(),
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Autorizatário',
                        prefixIcon: Icon(Icons.person_search,
                            color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  onSelected: (Autorizatario selection) {
                    onAutorizatarioChanged(selection.toString());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Row com campos numéricos (2 colunas)
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: vagasController,
                  label: 'Nº de Vagas',
                  icon: Icons.directions_car_filled,
                  keyboardType: TextInputType.number,
                  hint: 'ex: 4',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: telefoneController,
                  label: 'Telefone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  hint: 'ex: (61) 3321-8181',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid com campos booleanos (2x3)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildBooleanField(
                      label: 'Ponto Oficial',
                      icon: Icons.location_on,
                      value: pontoOficial,
                      onChanged: onPontoOficialChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Há Sinalização',
                      icon: Icons.signpost,
                      value: temSinalizacao,
                      onChanged: onTemSinalizacaoChanged,
                      context: context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem Abrigo',
                      icon: Icons.home_filled,
                      value: temAbrigo,
                      onChanged: onTemAbrigoChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem Energia',
                      icon: Icons.bolt,
                      value: temEnergia,
                      onChanged: onTemEnergiaChanged,
                      context: context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem Água',
                      icon: Icons.water_drop,
                      value: temAgua,
                      onChanged: onTemAguaChanged,
                      context: context,
                    ),
                  ),
                  const Expanded(child: SizedBox()), // Para manter alinhamento
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          //slider para notas
          Text(
            'Nota',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xFF2C3E50),
            ),
          ),
          Container(
            width: 480,
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<double>(
                    valueListenable: sliderValue,
                    builder: (context, value, _) {
                      final themeProvider = context.watch<ThemeProvider>();

                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbColor: themeProvider.primaryColor,
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Slider(
                          value: value,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: value.toStringAsFixed(0),
                          onChanged: (novoValor) {
                            sliderValue.value = novoValor;
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<double>(
                  valueListenable: sliderValue,
                  builder: (context, value, _) {
                    return Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.watch<ThemeProvider>().primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          CustomTextField(
            controller: observacoesController,
            label: 'Observações da Avaliação',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada.',
            maxLines: 3,
          ),
          const SizedBox(height: 20),

          // Seção de imagem
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão de seleção de imagem
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
                ],
              ),
              const SizedBox(width: 24),
              // Preview da imagem
              if ((imagemSelecionada?.isNotEmpty ?? false) &&
                  File(imagemSelecionada!).existsSync()) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Imagem selecionada:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: themeProvider.primaryColor
                                .withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(imagemSelecionada!),
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // Campo de observações (full width)
          CustomTextField(
            controller: observacoesController,
            label: 'Observações',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada.',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
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

          // Endereço com loading indicator
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

          DropdownButtonFormField<String>(
            value: [
              'Edificado',
              'Não Edificado',
              'Edificado Padrão Oscar Niemeyer'
            ].contains(classificacaoEstrutura)
                ? classificacaoEstrutura
                : null,
            decoration: InputDecoration(
              labelText: 'Tipo do Abrigo',
              prefixIcon: Icon(
                Icons.home_filled,
                color: themeProvider.primaryColor,
              ),
              labelStyle: TextStyle(
                color:
                    themeProvider.isDarkMode ? Colors.white70 : Colors.black87,
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
            items: [
              'Edificado',
              'Não Edificado',
              'Edificado Padrão Oscar Niemeyer'
            ]
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

          CustomTextField(
            controller: telefoneController,
            label: 'Telefone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            hint: 'ex: (61) 3321-8181',
          ),

          const SizedBox(height: 16),

          Autocomplete<Autorizatario>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<Autorizatario>.empty();
              }
              try {
                final results = await AutorizatarioService.buscarAutorizatarios(
                    textEditingValue.text);
                return results;
              } catch (e) {
                return const Iterable<Autorizatario>.empty();
              }
            },
            displayStringForOption: (Autorizatario option) => option.toString(),
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Autorizatário',
                  prefixIcon: Icon(Icons.person_search,
                      color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            onSelected: (Autorizatario selection) {
              onAutorizatarioChanged(selection.toString());
            },
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
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black87,
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

  @override
  Widget build(BuildContext context) {
    return _isDesktop(context)
        ? _buildDesktopLayout(context)
        : _buildMobileLayout(context);
  }
}
