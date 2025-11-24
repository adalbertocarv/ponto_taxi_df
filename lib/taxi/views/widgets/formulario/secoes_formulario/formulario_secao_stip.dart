import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponto_taxi_df/taxi/views/widgets/formulario/secoes_formulario/seletor_imagem.dart';
import 'package:provider/provider.dart';
import '../../../../providers/themes/tema_provider.dart';
import '../../../infraestrutura_dropdown.dart';
import 'custom_text_field.dart';
import 'formulario_header.dart';

class FormularioSectionSTIP extends StatefulWidget {
  final TextEditingController enderecoController;
  final TextEditingController observacoesController;
  final TextEditingController observacoesAvController;
  final TextEditingController vagasController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  final ValueChanged<String?> onClassificacaoChanged;
  final ValueChanged<int?> onIdChanged;

  // Campos booleanos específicos do STIP
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

  final String classificacaoEstrutura;
  final String? imagemSelecionada;
  final double valor;
  final bool isLoadingEndereco;

  // Callbacks específicos do STIP
  final Function(bool) onTemSanitariosMascFemChanged;
  final Function(bool) onTemChuveirosIndividuaisChanged;
  final Function(bool) onTemVestuariosChanged;
  final Function(bool) onTemSalaDescansoChanged;
  final Function(bool) onTemWifiChanged;
  final Function(bool) onTemPontosCarregarCelularChanged;
  final Function(bool) onTemEspacoRefeicaoChanged;
  final Function(bool) onTemEspacoEstacionarBikeChanged;
  final Function(bool) onTemPontoEsperaChanged;
  final Function(bool) onEmpresaGaranteManutencaoChanged;
  final Function(double) onNotaChanged;
  final Function(Uint8List?, String?) onImagemSelecionada;

  const FormularioSectionSTIP({
    super.key,
    required this.enderecoController,
    required this.observacoesController,
    required this.observacoesAvController,
    required this.vagasController,
    required this.latitudeController,
    required this.longitudeController,
    required this.classificacaoEstrutura,
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
    required this.imagemSelecionada,
    required this.onTemSanitariosMascFemChanged,
    required this.onTemChuveirosIndividuaisChanged,
    required this.onTemVestuariosChanged,
    required this.onTemSalaDescansoChanged,
    required this.onTemWifiChanged,
    required this.onTemPontosCarregarCelularChanged,
    required this.onTemEspacoRefeicaoChanged,
    required this.onTemEspacoEstacionarBikeChanged,
    required this.onTemPontoEsperaChanged,
    required this.onEmpresaGaranteManutencaoChanged,
    required this.onImagemSelecionada,
    required this.isLoadingEndereco,
    required this.valor,
    required this.onNotaChanged,
    required this.onClassificacaoChanged,
    required this.onIdChanged,
  });

  @override
  State<FormularioSectionSTIP> createState() => _FormularioSectionSTIPState();
}

class _FormularioSectionSTIPState extends State<FormularioSectionSTIP> {
  late ValueNotifier<double> sliderValue;

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

          // Row com Infraestrutura e Vagas
          Row(
            children: [
              Expanded(
                child: InfraestruturaDropdown(
                  initialValue: widget.classificacaoEstrutura.isNotEmpty
                      ? widget.classificacaoEstrutura
                      : null,
                  onChanged: (infra) {
                    widget.onClassificacaoChanged(infra.nomeInfraestrutura);
                    widget.onIdChanged(infra.idTipoInfraestrutura);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: widget.vagasController,
                  label: 'Nº de Vagas',
                  icon: Icons.directions_car_filled,
                  keyboardType: TextInputType.number,
                  hint: 'ex: 4',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Título da seção de infraestrutura
          Text(
            'Infraestrutura do Ponto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),

          // Grid com campos booleanos STIP (2 colunas)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem sanitários Masc/Fem?',
                      icon: Icons.wc,
                      value: widget.temSanitariosMascFem,
                      onChanged: widget.onTemSanitariosMascFemChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem chuveiros individuais?',
                      icon: Icons.shower,
                      value: widget.temChuveirosIndividuais,
                      onChanged: widget.onTemChuveirosIndividuaisChanged,
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
                      label: 'Tem vestuários?',
                      icon: Icons.checkroom,
                      value: widget.temVestuarios,
                      onChanged: widget.onTemVestuariosChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem sala de descanso?',
                      icon: Icons.bed,
                      value: widget.temSalaDescanso,
                      onChanged: widget.onTemSalaDescansoChanged,
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
                      label: 'Tem wi-fi?',
                      icon: Icons.wifi,
                      value: widget.temWifi,
                      onChanged: widget.onTemWifiChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem pontos para carregar celular?',
                      icon: Icons.charging_station,
                      value: widget.temPontosCarregarCelular,
                      onChanged: widget.onTemPontosCarregarCelularChanged,
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
                      label: 'Tem espaço para refeição?',
                      icon: Icons.restaurant,
                      value: widget.temEspacoRefeicao,
                      onChanged: widget.onTemEspacoRefeicaoChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'Tem espaço para estacionar bike?',
                      icon: Icons.pedal_bike,
                      value: widget.temEspacoEstacionarBike,
                      onChanged: widget.onTemEspacoEstacionarBikeChanged,
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
                      label: 'Tem ponto de espera?',
                      icon: Icons.event_seat,
                      value: widget.temPontoEspera,
                      onChanged: widget.onTemPontoEsperaChanged,
                      context: context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBooleanField(
                      label: 'A empresa garante a manutenção completa?',
                      icon: Icons.build,
                      value: widget.empresaGaranteManutencao,
                      onChanged: widget.onEmpresaGaranteManutencaoChanged,
                      context: context,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Slider para notas
          _buildSliderSection(),

          const SizedBox(height: 20),

          CustomTextField(
            controller: widget.observacoesAvController,
            label: 'Observações da avaliação',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada. Há 06 vagas na saída',
            maxLines: 3,
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
            hint: 'Ex: Detalhes sobre a situação atual do ponto, obras, vagas, etc.',
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
          const SizedBox(height: 16),

          // Dropdown de Infraestrutura
          InfraestruturaDropdown(
            initialValue: widget.classificacaoEstrutura.isNotEmpty
                ? widget.classificacaoEstrutura
                : null,
            onChanged: (infra) {
              widget.onClassificacaoChanged(infra.nomeInfraestrutura);
              widget.onIdChanged(infra.idTipoInfraestrutura);
            },
          ),

          const SizedBox(height: 16),

          // Campo de Vagas
          CustomTextField(
            controller: widget.vagasController,
            label: 'Nº de Vagas',
            icon: Icons.directions_car_filled,
            keyboardType: TextInputType.number,
            hint: 'ex: 4',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),

          const SizedBox(height: 20),

          // Título da seção
          Text(
            'Infraestrutura do Ponto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),

          // Campos booleanos (mobile - um por linha)
          buildBooleanField(
            label: 'Tem sanitários Masc/Fem?',
            icon: Icons.wc,
            value: widget.temSanitariosMascFem,
            onChanged: widget.onTemSanitariosMascFemChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem chuveiros individuais?',
            icon: Icons.shower,
            value: widget.temChuveirosIndividuais,
            onChanged: widget.onTemChuveirosIndividuaisChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem vestuários?',
            icon: Icons.checkroom,
            value: widget.temVestuarios,
            onChanged: widget.onTemVestuariosChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem sala de descanso?',
            icon: Icons.bed,
            value: widget.temSalaDescanso,
            onChanged: widget.onTemSalaDescansoChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem wi-fi?',
            icon: Icons.wifi,
            value: widget.temWifi,
            onChanged: widget.onTemWifiChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem pontos para carregar celular?',
            icon: Icons.charging_station,
            value: widget.temPontosCarregarCelular,
            onChanged: widget.onTemPontosCarregarCelularChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem espaço para refeição?',
            icon: Icons.restaurant,
            value: widget.temEspacoRefeicao,
            onChanged: widget.onTemEspacoRefeicaoChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem espaço para estacionar bike?',
            icon: Icons.pedal_bike,
            value: widget.temEspacoEstacionarBike,
            onChanged: widget.onTemEspacoEstacionarBikeChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'Tem ponto de espera?',
            icon: Icons.event_seat,
            value: widget.temPontoEspera,
            onChanged: widget.onTemPontoEsperaChanged,
            context: context,
          ),

          buildBooleanField(
            label: 'A empresa garante a manutenção completa?',
            icon: Icons.build,
            value: widget.empresaGaranteManutencao,
            onChanged: widget.onEmpresaGaranteManutencaoChanged,
            context: context,
          ),

          const SizedBox(height: 16),

          // Slider para notas no mobile
          _buildSliderSection(),

          const SizedBox(height: 16),

          CustomTextField(
            controller: widget.observacoesAvController,
            label: 'Observações da avaliação',
            icon: Icons.notes_rounded,
            hint: 'Ex: Não há obra a ser executada. Há 06 vagas na saída',
            maxLines: 3,
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
            hint: 'Ex: Detalhes sobre a situação atual do ponto, obras, vagas, etc.',
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