import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ponto_taxi_df/taxi/controllers/mapa_controller.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../../services/endereco_osm_service.dart';
import '../../services/login_service.dart';
import '../../services/pre_cadastro_stip_service.dart';
import '../widgets/formulario/pontos_salvos/pontos_salvos_secao.dart';
import '../widgets/formulario/secoes_formulario/formulario_secao_stip.dart';
import '../widgets/formulario/botoes_acao/botoes_acao_secao.dart';
import 'home/tela_inicio.dart';

class FormularioSTIP extends StatefulWidget {
  final List<Marker> pontos;
  const FormularioSTIP({super.key, required this.pontos});

  @override
  State<FormularioSTIP> createState() => _FormularioSTIPState();
}

class _FormularioSTIPState extends State<FormularioSTIP> {
  // Serviços
  final PreCadastroStipService _stipService = PreCadastroStipService();
  final EnderecoService _enderecoService = EnderecoService();

  // Controllers
  final _enderecoController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _vagasController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _observacoesAvController = TextEditingController();

  // Campos booleanos baseados na tabela
  bool _temSanitariosMascFem = false;
  bool _temChuveirosIndividuais = false;
  bool _temVestuarios = false;
  bool _temSalaDescanso = false;
  bool _temWifi = false;
  bool _temPontosCarregarCelular = false;
  bool _temEspacoRefeicao = false;
  bool _temEspacoEstacionarBike = false;
  bool _temPontoEspera = false;
  bool _empresaGaranteManutencao = false;

  // Infraestrutura
  String _classificacaoEstrutura = '';
  int _idTipoInfraestrutura = 0;

  // Outros dados
  String? _imagemPath;
  Uint8List? _webImage;
  double _notaAvaliacao = 1.0;

  bool _isLoadingEndereco = true;
  bool _isSaving = false;

  int? _userId;

  @override
  void initState() {
    super.initState();
    _carregarEndereco();
    _preencherCoordenadas();
    _loadUserId();
  }

  void _loadUserId() async {
    final id = await LoginService.getUsuarioId();
    if (mounted) {
      setState(() {
        _userId = id;
      });
    }
  }

  Future<void> _carregarEndereco() async {
    final endereco = await _enderecoService.obterEnderecoFormatado(widget.pontos);
    if (mounted) {
      setState(() {
        _enderecoController.text = endereco ?? '';
        _isLoadingEndereco = false;
      });
    }
  }

  void _preencherCoordenadas() {
    if (widget.pontos.isNotEmpty) {
      final marker = widget.pontos.first;
      _latitudeController.text = marker.point.latitude.toString();
      _longitudeController.text = marker.point.longitude.toString();
    }
  }

  void _onImagemSelecionada(Uint8List? webImage, String? path) {
    setState(() {
      _webImage = webImage;
      _imagemPath = path;
    });
  }

  // Callback para quando a infraestrutura for alterada
  void _onClassificacaoChanged(String? value) {
    if (value == null) return;
    setState(() {
      _classificacaoEstrutura = value;
    });
  }

  // Callback para quando o ID da infraestrutura vier do dropdown
  void _onIdInfraestruturaChanged(int? id) {
    if (id != null) {
      setState(() {
        _idTipoInfraestrutura = id;
      });
    }
  }

  Future<void> _salvar() async {
    if (_isSaving) {
      return;
    }


    // Validação do usuário
    if (_userId == null) {
      _mostrarErro('Erro: Usuário não identificado. Faça login novamente.');
      return;
    }

    // Validações básicas
    if (_enderecoController.text.trim().isEmpty) {
      _mostrarErro('Endereço é obrigatório');
      return;
    }

    if (_vagasController.text.trim().isEmpty) {
      _mostrarErro('Número de vagas é obrigatório');
      return;
    }

    final numVagas = int.tryParse(_vagasController.text.trim());
    if (numVagas == null || numVagas <= 0) {
      _mostrarErro('Número de vagas inválido');
      return;
    }

    if (_idTipoInfraestrutura == 0) {
      _mostrarErro('Selecione o tipo de infraestrutura');
      return;
    }

    if (widget.pontos.isEmpty) {
      _mostrarErro('Nenhum ponto marcado no mapa');
      return;
    }


    setState(() => _isSaving = true);

    try {
      final marker = widget.pontos.first;


      final sucesso = await _stipService.salvarPontoStip(
        idUsuario: _userId!,
        latitude: marker.point.latitude,
        longitude: marker.point.longitude,
        endereco: _enderecoController.text.trim(),
        idTipoInfraestrutura: _idTipoInfraestrutura,
        numVagas: numVagas,
        codAvaliacao: _notaAvaliacao.toInt(),
        descAvaliacao: _observacoesAvController.text.trim().isEmpty
            ? 'Sem observações de avaliação'
            : _observacoesAvController.text.trim(),
        observacao: _observacoesController.text.trim().isEmpty
            ? 'Sem observações'
            : _observacoesController.text.trim(),
        // Campos específicos STIP
        sanitarios: _temSanitariosMascFem,
        chuveiros: _temChuveirosIndividuais,
        vestiarios: _temVestuarios,
        salaRepouso: _temSalaDescanso,
        sinalInternet: _temWifi,
        pontoRecarga: _temPontosCarregarCelular,
        refeitorio: _temEspacoRefeicao,
        bicicletario: _temEspacoEstacionarBike,
        salaEspera: _temPontoEspera,
        ambienteManutencao: _empresaGaranteManutencao,
        webImage: _webImage,
        caminhoImagem: _imagemPath,
      );

      if (!mounted) return;

      if (sucesso) {

        final mapaController = context.read<MapaController>();
        mapaController.showSuccess('Ponto STIP salvo com sucesso! 🎉');

        await _mostrarDialogoSucesso();
        _limparFormulario();
      } else {
        _mostrarErro('Erro ao salvar o ponto. Verifique os dados e tente novamente.');
      }
    } catch (e, stackTrace) {

      if (mounted) {
        _mostrarErro('Erro inesperado ao salvar o ponto. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _mostrarDialogoSucesso() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 32),
              SizedBox(width: 12),
              Text('Sucesso!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ponto STIP cadastrado com sucesso!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Endereço', _enderecoController.text),
                    const SizedBox(height: 8),
                    _buildInfoRow('Vagas', _vagasController.text),
                    const SizedBox(height: 8),
                    _buildInfoRow('Avaliação', '${_notaAvaliacao.toInt()}/5'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final mapaController = context.read<MapaController>();
                mapaController.limparMarkers();

                await Future.delayed(const Duration(milliseconds: 100));

                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const TelaInicioPage()),
                        (route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _limparFormulario() {
    _enderecoController.clear();
    _observacoesController.clear();
    _observacoesAvController.clear();
    _vagasController.clear();

    setState(() {
      _temSanitariosMascFem = false;
      _temChuveirosIndividuais = false;
      _temVestuarios = false;
      _temSalaDescanso = false;
      _temWifi = false;
      _temPontosCarregarCelular = false;
      _temEspacoRefeicao = false;
      _temEspacoEstacionarBike = false;
      _temPontoEspera = false;
      _empresaGaranteManutencao = false;
      _classificacaoEstrutura = '';
      _idTipoInfraestrutura = 0;
      _imagemPath = null;
      _webImage = null;
      _notaAvaliacao = 1.0;
    });
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: const Color(0xFFE74C3C),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 780;
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PontosSalvosSecao(pontos: widget.pontos),
          const SizedBox(height: 24),
          FormularioSectionSTIP(
            enderecoController: _enderecoController,
            observacoesController: _observacoesController,
            observacoesAvController: _observacoesAvController,
            vagasController: _vagasController,
            latitudeController: _latitudeController,
            longitudeController: _longitudeController,
            classificacaoEstrutura: _classificacaoEstrutura,
            temSanitariosMascFem: _temSanitariosMascFem,
            temChuveirosIndividuais: _temChuveirosIndividuais,
            temVestuarios: _temVestuarios,
            temSalaDescanso: _temSalaDescanso,
            temWifi: _temWifi,
            temPontosCarregarCelular: _temPontosCarregarCelular,
            temEspacoRefeicao: _temEspacoRefeicao,
            temEspacoEstacionarBike: _temEspacoEstacionarBike,
            temPontoEspera: _temPontoEspera,
            empresaGaranteManutencao: _empresaGaranteManutencao,
            isLoadingEndereco: _isLoadingEndereco,
            imagemSelecionada: _imagemPath,
            valor: _notaAvaliacao,
            onTemSanitariosMascFemChanged: (v) => setState(() => _temSanitariosMascFem = v),
            onTemChuveirosIndividuaisChanged: (v) => setState(() => _temChuveirosIndividuais = v),
            onTemVestuariosChanged: (v) => setState(() => _temVestuarios = v),
            onTemSalaDescansoChanged: (v) => setState(() => _temSalaDescanso = v),
            onTemWifiChanged: (v) => setState(() => _temWifi = v),
            onTemPontosCarregarCelularChanged: (v) => setState(() => _temPontosCarregarCelular = v),
            onTemEspacoRefeicaoChanged: (v) => setState(() => _temEspacoRefeicao = v),
            onTemEspacoEstacionarBikeChanged: (v) => setState(() => _temEspacoEstacionarBike = v),
            onTemPontoEsperaChanged: (v) => setState(() => _temPontoEspera = v),
            onEmpresaGaranteManutencaoChanged: (v) => setState(() => _empresaGaranteManutencao = v),
            onImagemSelecionada: _onImagemSelecionada,
            onNotaChanged: (v) => setState(() => _notaAvaliacao = v),
            onClassificacaoChanged: _onClassificacaoChanged,
            onIdChanged: _onIdInfraestruturaChanged,
          ),
          const SizedBox(height: 32),
          BotoesAcaoSecao(
            enderecoController: _enderecoController,
            observacoesController: _observacoesController,
            vagasController: _vagasController,
            onSalvar: _salvar,
            isLoading: _isSaving,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildBackButton(context),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        PontosSalvosSecao(pontos: widget.pontos),
                        const SizedBox(height: 24),
                        _buildCoordenadasCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        FormularioSectionSTIP(
                          enderecoController: _enderecoController,
                          observacoesController: _observacoesController,
                          observacoesAvController: _observacoesAvController,
                          vagasController: _vagasController,
                          latitudeController: _latitudeController,
                          longitudeController: _longitudeController,
                          classificacaoEstrutura: _classificacaoEstrutura,
                          temSanitariosMascFem: _temSanitariosMascFem,
                          temChuveirosIndividuais: _temChuveirosIndividuais,
                          temVestuarios: _temVestuarios,
                          temSalaDescanso: _temSalaDescanso,
                          temWifi: _temWifi,
                          temPontosCarregarCelular: _temPontosCarregarCelular,
                          temEspacoRefeicao: _temEspacoRefeicao,
                          temEspacoEstacionarBike: _temEspacoEstacionarBike,
                          temPontoEspera: _temPontoEspera,
                          empresaGaranteManutencao: _empresaGaranteManutencao,
                          isLoadingEndereco: _isLoadingEndereco,
                          imagemSelecionada: _imagemPath,
                          valor: _notaAvaliacao,
                          onTemSanitariosMascFemChanged: (v) => setState(() => _temSanitariosMascFem = v),
                          onTemChuveirosIndividuaisChanged: (v) => setState(() => _temChuveirosIndividuais = v),
                          onTemVestuariosChanged: (v) => setState(() => _temVestuarios = v),
                          onTemSalaDescansoChanged: (v) => setState(() => _temSalaDescanso = v),
                          onTemWifiChanged: (v) => setState(() => _temWifi = v),
                          onTemPontosCarregarCelularChanged: (v) => setState(() => _temPontosCarregarCelular = v),
                          onTemEspacoRefeicaoChanged: (v) => setState(() => _temEspacoRefeicao = v),
                          onTemEspacoEstacionarBikeChanged: (v) => setState(() => _temEspacoEstacionarBike = v),
                          onTemPontoEsperaChanged: (v) => setState(() => _temPontoEspera = v),
                          onEmpresaGaranteManutencaoChanged: (v) => setState(() => _empresaGaranteManutencao = v),
                          onImagemSelecionada: _onImagemSelecionada,
                          onNotaChanged: (v) => setState(() => _notaAvaliacao = v),
                          onClassificacaoChanged: _onClassificacaoChanged,
                          onIdChanged: _onIdInfraestruturaChanged,
                        ),
                        const SizedBox(height: 32),
                        BotoesAcaoSecao(
                          enderecoController: _enderecoController,
                          observacoesController: _observacoesController,
                          vagasController: _vagasController,
                          onSalvar: _salvar,
                          isLoading: _isSaving,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoordenadasCard() {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final marker = widget.pontos.first;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF4A90E2),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Coordenadas',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildCoordenadasItem(
                  'Latitude',
                  marker.point.latitude.toStringAsFixed(6),
                  Icons.horizontal_rule,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCoordenadasItem(
                  'Longitude',
                  marker.point.longitude.toStringAsFixed(6),
                  Icons.vertical_align_center,
                  themeProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordenadasItem(
      String label,
      String value,
      IconData icon,
      ThemeProvider themeProvider,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Colors.grey.shade700
              : const Color(0xFFE9ECEF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeProvider.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      appBar: !_isDesktop(context)
          ? AppBar(
        title: const Text(
          'Formulário STIP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      )
          : null,
      body: SafeArea(
        child: _isSaving
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF27AE60),
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Salvando ponto STIP...',
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            ],
          ),
        )
            : _isDesktop(context)
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    _observacoesController.dispose();
    _vagasController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _observacoesAvController.dispose();
    super.dispose();
  }
}