import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponto_taxi_df/taxi/views/widgets/formulario/secoes_formulario/seletor_imagem.dart';
import 'package:provider/provider.dart';
import '../../../../models/autorizatario.dart';
import '../../../../providers/themes/tema_provider.dart';
import '../../../../services/autorizatario_service.dart';
import '../../../infraestrutura_dropdown.dart';
import 'custom_text_field.dart';
import 'formulario_header.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormularioSection extends StatefulWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final TextEditingController observacoesAvController;
  final TextEditingController vagasController;
  final TextEditingController telefoneController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final ValueChanged<String?> onClassificacaoChanged;
  final ValueChanged<int?> onIdChanged;

  final bool pontoOficial;
  final bool temSinalizacao;
  final bool temAbrigo;
  final bool temEnergia;
  final bool temAgua;

  final String classificacaoEstrutura;
  final String autorizatario;
  final String? imagemSelecionada;
  final double valor;
  final bool isLoadingEndereco;

  final Function(bool) onPontoOficialChanged;
  final Function(bool) onTemSinalizacaoChanged;
  final Function(bool) onTemAbrigoChanged;
  final Function(bool) onTemEnergiaChanged;
  final Function(bool) onTemAguaChanged;
  final Function(String?) onAutorizatarioChanged;
  final Function(double) onNotaChanged; // Nova callback para nota
  final Function(Uint8List?, String?) onImagemSelecionada; // Atualizada

  const FormularioSection({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.observacoesAvController,
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
    required this.onIdChanged,
    required this.onTemSinalizacaoChanged,
    required this.onTemAbrigoChanged,
    required this.onTemEnergiaChanged,
    required this.onTemAguaChanged,
    required this.onClassificacaoChanged,
    required this.onAutorizatarioChanged,
    required this.onImagemSelecionada,
    required this.isLoadingEndereco,
    required this.valor,
    required this.onNotaChanged,
  });

  @override
  State<FormularioSection> createState() => _FormularioSectionState();
}

class _FormularioSectionState extends State<FormularioSection> {
  late ValueNotifier<double> sliderValue;

  //---------------------------------------------------------
  //---------------------------------------------------------
  // O FORMATO ESTÁ EM TELEFONE FIXO (SEM O 9 DE PREFIXO)
  //PARA ADICIONAR O NOVE, ADICIONE MAIS UM "#" NO "mask"
  //---------------------------------------------------------
  //---------------------------------------------------------

  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #########',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    sliderValue = ValueNotifier(widget.valor);
  }

  @override
  void dispose() {
    sliderValue.dispose();
    super.dispose();
  }

  // Função para determinar se é desktop/tablet
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
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

  Widget _buildSliderSection() {
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avaliação da infraestrutura',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode
                ? Colors.white
                : const Color(0xFF2C3E50),
          ),
        ),
        SizedBox(
          width: _isDesktop(context) ? 480 : double.infinity,
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: sliderValue,
                  builder: (context, value, _) {
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
                          widget.onNotaChanged(novoValor);
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
                      color: themeProvider.primaryColor,
                    ),
                  );
                },
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
                  controller: widget.enderecoController,
                  label: 'Endereço',
                  icon: Icons.location_on_outlined,
                  hint: widget.isLoadingEndereco
                      ? 'Buscando endereço...'
                      : 'Ex: Asa Norte SQN 410',
                  maxLines: 2,
                ),
              ),
              if (widget.isLoadingEndereco) ...[
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
                child: Autocomplete<Autorizatario>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Autorizatario>.empty();
                    }
                    try {
                      final results = await AutorizatarioService.buscarAutorizatarios(textEditingValue.text);
                      return results;
                    } catch (e) {
                      return const Iterable<Autorizatario>.empty();
                    }
                  },
                  displayStringForOption: (Autorizatario option) => option.toString(),
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Autorizatário',
                        prefixIcon: Icon(Icons.person_search, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  onSelected: (Autorizatario selection) {
                    widget.onAutorizatarioChanged(selection.toString());
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          InfraestruturaDropdown(
            initialValue: widget.classificacaoEstrutura, // se houver
            onChanged: (infra) {
              widget.onClassificacaoChanged(infra.nomeInfraestrutura);
              // Se precisar do id também:
              widget.onIdChanged(infra.idTipoInfraestrutura);
            },
          ),

          const SizedBox(height: 20),

          // Row com campos numéricos (2 colunas)
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: widget.vagasController,
                  label: 'Nº de Vagas',
                  icon: Icons.directions_car_filled,
                  keyboardType: TextInputType.number,
                  hint: 'ex: 4',
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // permite apenas números
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: widget.telefoneController,
                  label: 'Telefone',
                  icon: Icons.phone,
                  //keyboardType: TextInputType.phone,
                  hint: 'ex: (61) 3321-8181',
                  //maxLength: 11,
                  inputFormatters: [
                    phoneFormatter,
                  ],
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
                      value: widget.pontoOficial,
                      onChanged: widget.onPontoOficialChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Há Sinalização',
                      icon: Icons.signpost,
                      value: widget.temSinalizacao,
                      onChanged: widget.onTemSinalizacaoChanged,
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
                      value: widget.temAbrigo,
                      onChanged: widget.onTemAbrigoChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem Energia',
                      icon: Icons.bolt,
                      value: widget.temEnergia,
                      onChanged: widget.onTemEnergiaChanged,
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
                      value: widget.temAgua,
                      onChanged: widget.onTemAguaChanged,
                      context: context,
                    ),
                  ),
                  const Expanded(child: SizedBox()), // Para manter alinhamento
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Slider para notas
          _buildSliderSection(),

          const SizedBox(height: 20),

          CustomTextField(
            controller: widget.observacoesAvController,
            label: 'Observações da avaliação',
            icon: Icons.notes_rounded,
            hint: 'Ex: Estrutura precarizada',
            maxLines: 3,
            //maxLength: 200,
          ),

          const SizedBox(height: 20),

          // Seção de imagem
          SeletorImagem(
            imagemSelecionada: widget.imagemSelecionada ?? '',
            onImagemSelecionada: widget.onImagemSelecionada,
          ),

          const SizedBox(height: 20),

          // Campo de observações (full width)
          CustomTextField(
            controller: widget.observacoesController,
            label: 'Observações',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada.',
            maxLines: 3,
            //maxLength: 200,
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
                  controller: widget.enderecoController,
                  label: 'Endereço',
                  icon: Icons.location_on_outlined,
                  hint: widget.isLoadingEndereco
                      ? 'Buscando endereço...'
                      : 'Ex: Asa Norte SQN 410',
                  maxLines: 2,
                ),
              ),
              if (widget.isLoadingEndereco) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: <String>[
              'Edificado',
              'Não Edificado',
              'Edificado Padrão Oscar Niemeyer'
            ].contains(widget.classificacaoEstrutura)
                ? widget.classificacaoEstrutura
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
            onChanged: widget.onClassificacaoChanged,
          ),

          const SizedBox(height: 16),

          buildBooleanField(
            label: 'Ponto Oficial',
            icon: Icons.location_on,
            value: widget.pontoOficial,
            onChanged: widget.onPontoOficialChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Há Sinalização',
            icon: Icons.signpost,
            value: widget.temSinalizacao,
            onChanged: widget.onTemSinalizacaoChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem Abrigo',
            icon: Icons.home_filled,
            value: widget.temAbrigo,
            onChanged: widget.onTemAbrigoChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem Energia',
            icon: Icons.bolt,
            value: widget.temEnergia,
            onChanged: widget.onTemEnergiaChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem Água',
            icon: Icons.water_drop,
            value: widget.temAgua,
            onChanged: widget.onTemAguaChanged,
            context: context,
          ),

          CustomTextField(
            controller: widget.vagasController,
            label: 'Nº de Vagas',
            icon: Icons.directions_car_filled,
            keyboardType: TextInputType.number,
            hint: 'ex: 4',
            //maxLength: 2,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: widget.telefoneController,
            label: 'Telefone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            hint: 'ex: (61) 3321-8181',
            //maxLength: 11,
            inputFormatters: [
              phoneFormatter,
            ],
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
              widget.onAutorizatarioChanged(selection.toString());
            },
          ),

          const SizedBox(height: 16),

          // Slider para notas no mobile
          _buildSliderSection(),

          const SizedBox(height: 16),

          CustomTextField(
            controller: widget.observacoesAvController,
            label: 'Observações da avaliação',
            icon: Icons.notes_rounded,
            hint: 'Ex: Estrutura precarizada',
            maxLines: 3,
            //maxLength: 200,
          ),

          const SizedBox(height: 16),

          SeletorImagem(
            imagemSelecionada: widget.imagemSelecionada ?? '',
            onImagemSelecionada: widget.onImagemSelecionada,
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: widget.observacoesController,
            label: 'Observações',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada.',
            maxLines: 3,
            //maxLength: 200,
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
