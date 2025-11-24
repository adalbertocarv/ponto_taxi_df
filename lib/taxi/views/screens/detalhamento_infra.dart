import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/providers/themes/tema_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetalheInfraestrutura extends StatefulWidget {
  final dynamic infraestrutura;

  const DetalheInfraestrutura({super.key, required this.infraestrutura});

  @override
  State<DetalheInfraestrutura> createState() => _DetalheInfraestruturaState();
}

class _DetalheInfraestruturaState extends State<DetalheInfraestrutura> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSaving = false;

  // Controllers
  late TextEditingController _enderecoController;
  late TextEditingController _numVagasController;
  late TextEditingController _observacaoController;
  late TextEditingController _descAvaliacaoController;

  // Valores editáveis
  late double _latitude;
  late double _longitude;
  late String _codAvaliacao;
  late bool _abrigo;
  late bool _sinalizacao;
  late bool _energia;
  late bool _agua;
  late bool _pontoOficial;

  //final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _enderecoController = TextEditingController(
        text: widget.infraestrutura['endereco'] ?? '');
    _numVagasController = TextEditingController(
        text: widget.infraestrutura['num_vagas']?.toString() ?? '0');
    _observacaoController = TextEditingController(
        text: widget.infraestrutura['observacao'] ?? '');
    _descAvaliacaoController = TextEditingController(
        text: widget.infraestrutura['desc_avaliacao'] ?? '');

    _latitude = widget.infraestrutura['latitude']?.toDouble() ?? 0.0;
    _longitude = widget.infraestrutura['longitude']?.toDouble() ?? 0.0;
    _codAvaliacao = widget.infraestrutura['cod_avaliacao']?.toString() ?? '3';
    _abrigo = widget.infraestrutura['abrigo'] ?? false;
    _sinalizacao = widget.infraestrutura['sinalizacao'] ?? false;
    _energia = widget.infraestrutura['energia'] ?? false;
    _agua = widget.infraestrutura['agua'] ?? false;
    _pontoOficial = widget.infraestrutura['ponto_oficial'] ?? false;
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    _numVagasController.dispose();
    _observacaoController.dispose();
    _descAvaliacaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final id = widget.infraestrutura['id_pre_infraestrutura'];
    final url = 'https://lathiest-gustily-carri.ngrok-free.dev/pre/cadastro/infraestrutura/$id';

    final body = {
      'id_tipo_infraestrutura': widget.infraestrutura['id_tipo_infraestrutura'],
      'id_usuario': widget.infraestrutura['id_usuario'],
      'id_grupo_infraestrutura': widget.infraestrutura['id_grupo_infraestrutura'],
      'id_autorizatario': widget.infraestrutura['id_autorizatario'],
      'latitude': _latitude,
      'longitude': _longitude,
      'endereco': _enderecoController.text,
      'cod_avaliacao': _codAvaliacao,
      'desc_avaliacao': _descAvaliacaoController.text,
      'observacao': _observacaoController.text,
      'num_vagas': _numVagasController.text,
      'abrigo': _abrigo,
      'sinalizacao': _sinalizacao,
      'energia': _energia,
      'agua': _agua,
      'ponto_oficial': _pontoOficial,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Infraestrutura atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _isEditing = false;
            // Atualiza os dados locais
            widget.infraestrutura['latitude'] = _latitude;
            widget.infraestrutura['longitude'] = _longitude;
            widget.infraestrutura['endereco'] = _enderecoController.text;
            widget.infraestrutura['num_vagas'] = _numVagasController.text;
            widget.infraestrutura['observacao'] = _observacaoController.text;
            widget.infraestrutura['desc_avaliacao'] = _descAvaliacaoController.text;
            widget.infraestrutura['cod_avaliacao'] = _codAvaliacao;
            widget.infraestrutura['abrigo'] = _abrigo;
            widget.infraestrutura['sinalizacao'] = _sinalizacao;
            widget.infraestrutura['energia'] = _energia;
            widget.infraestrutura['agua'] = _agua;
            widget.infraestrutura['ponto_oficial'] = _pontoOficial;
          });
        }
      } else {
        throw Exception('Erro ao atualizar: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _cancelarEdicao() {
    setState(() {
      _isEditing = false;
      _initializeControllers();
    });
  }

  void _mostrarMapaParaEdicao() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MapaPicker(
        latitude: _latitude,
        longitude: _longitude,
        onLocationSelected: (lat, lng) {
          setState(() {
            _latitude = lat;
            _longitude = lng;
          });
        },
      ),
    );
  }

  String _getImageUrl(String? imgPath) {
    if (imgPath == null) return '';
    final fileName = imgPath.split('\\').last;
    return 'https://lathiest-gustily-carri.ngrok-free.dev/uploads/$fileName';
  }

  String _getTipoInfraestrutura(int tipo) {
    final tipos = {
      23: 'Edificado',
      24: 'Edificado Padrão Oscar Niemeyer',
      25: 'Não Edificado',
    };
    return tipos[tipo] ?? 'Tipo $tipo';
  }

  String _getAvaliacaoTexto(String? cod) {
    final avaliacoes = {
      '1': 'Ruim',
      '2': 'Regular',
      '3': 'Bom',
      '4': 'Muito Bom',
      '5': 'Excelente',
    };
    return avaliacoes[cod] ?? 'Não avaliado';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final imageUrl = _getImageUrl(widget.infraestrutura['img_infraestrutura']);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Infraestrutura' : 'Detalhes da Infraestrutura'),
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelarEdicao,
            ),
            IconButton(
              icon: _isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Icon(Icons.check),
              onPressed: _isSaving ? null : _salvarAlteracoes,
            ),
          ],
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isDesktop ? 1000 : double.infinity),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagem principal
                  Container(
                    height: isDesktop ? 400 : 250,
                    color: Colors.grey[300],
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      headers: const {
                        'ngrok-skip-browser-warning': 'true',
                      },
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.image_not_supported,
                              size: 64, color: Colors.grey[600]),
                        );
                      },
                    )

                        : Center(
                      child: Icon(Icons.location_on,
                          size: 64, color: Colors.grey[600]),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título e tipo
                        Row(
                          children: [
                            Icon(Icons.location_city,
                                color: themeProvider.primaryColor, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getTipoInfraestrutura(
                                        widget.infraestrutura['id_tipo_infraestrutura']),
                                    style: TextStyle(
                                      fontSize: isDesktop ? 28 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${widget.infraestrutura['id_pre_infraestrutura']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Endereço
                        _buildSectionTitle(Icons.location_on, 'Endereço', themeProvider),
                        const SizedBox(height: 8),
                        _isEditing
                            ? TextFormField(
                          controller: _enderecoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Endereço',
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, informe o endereço';
                            }
                            return null;
                          },
                        )
                            : Text(
                          widget.infraestrutura['endereco'] ?? 'Não informado',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),

                        // Coordenadas
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.pin_drop, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Lat: ${_latitude.toStringAsFixed(6)}',
                                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.pin_drop, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Long: ${_longitude.toStringAsFixed(6)}',
                                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (_isEditing)
                              ElevatedButton.icon(
                                onPressed: _mostrarMapaParaEdicao,
                                icon: const Icon(Icons.map),
                                label: const Text('Editar no Mapa'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeProvider.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Informações principais
                        _buildSectionTitle(Icons.info_outline, 'Informações', themeProvider),
                        const SizedBox(height: 12),

                        isDesktop
                            ? Row(
                          children: [
                            Expanded(child: _buildInfoSection()),
                            const SizedBox(width: 24),
                            Expanded(child: _buildCaracteristicas(themeProvider)),
                          ],
                        )
                            : Column(
                          children: [
                            _buildInfoSection(),
                            const SizedBox(height: 16),
                            _buildCaracteristicas(themeProvider),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Avaliação
                        _buildSectionTitle(Icons.star, 'Avaliação', themeProvider),
                        const SizedBox(height: 12),
                        _buildAvaliacaoSection(themeProvider),

                        // Observações
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildSectionTitle(Icons.notes, 'Observações', themeProvider),
                        const SizedBox(height: 12),
                        _isEditing
                            ? TextFormField(
                          controller: _observacaoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Observações',
                          ),
                          maxLines: 4,
                        )
                            : Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.infraestrutura['observacao']?.isEmpty ?? true
                                ? 'Sem observações'
                                : widget.infraestrutura['observacao'],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, ThemeProvider themeProvider) {
    return Row(
      children: [
        Icon(icon, color: themeProvider.primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        if (_isEditing)
          TextFormField(
            controller: _numVagasController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de Vagas',
              prefixIcon: Icon(Icons.local_parking),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o número de vagas';
              }
              if (int.tryParse(value) == null) {
                return 'Número inválido';
              }
              return null;
            },
          )
        else
          _buildInfoRow('Número de Vagas', '${widget.infraestrutura['num_vagas'] ?? 'N/A'}'),
        const SizedBox(height: 12),
        _buildInfoRow('Grupo', 'ID ${widget.infraestrutura['id_grupo_infraestrutura'] ?? 'N/A'}'),
        _buildInfoRow('Autorizatário', 'ID ${widget.infraestrutura['id_autorizatario'] ?? 'N/A'}'),
        _buildInfoRow('Usuário', 'ID ${widget.infraestrutura['id_usuario'] ?? 'N/A'}'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaracteristicas(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Características',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        if (_isEditing) ...[
          CheckboxListTile(
            title: const Text('Abrigo'),
            value: _abrigo,
            onChanged: (value) => setState(() => _abrigo = value ?? false),
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Sinalização'),
            value: _sinalizacao,
            onChanged: (value) => setState(() => _sinalizacao = value ?? false),
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Energia'),
            value: _energia,
            onChanged: (value) => setState(() => _energia = value ?? false),
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Água'),
            value: _agua,
            onChanged: (value) => setState(() => _agua = value ?? false),
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Ponto Oficial'),
            value: _pontoOficial,
            onChanged: (value) => setState(() => _pontoOficial = value ?? false),
            dense: true,
          ),
        ] else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Abrigo', _abrigo),
              _buildChip('Sinalização', _sinalizacao),
              _buildChip('Energia', _energia),
              _buildChip('Água', _agua),
              _buildChip('Ponto Oficial', _pontoOficial),
            ],
          ),
      ],
    );
  }

  Widget _buildChip(String label, bool hasFeature) {
    return Chip(
      avatar: Icon(
        hasFeature ? Icons.check_circle : Icons.cancel,
        color: hasFeature ? Colors.green : Colors.red,
        size: 18,
      ),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      backgroundColor: hasFeature ? Colors.green[50] : Colors.red[50],
    );
  }

  Widget _buildAvaliacaoSection(ThemeProvider themeProvider) {
    if (_isEditing) {
      return Column(
        children: [
          DropdownButtonFormField<String>(
            value: _codAvaliacao,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Avaliação',
              prefixIcon: Icon(Icons.star),
            ),
            items: [
              {'cod': '1', 'desc': 'Ruim'},
              {'cod': '2', 'desc': 'Regular'},
              {'cod': '3', 'desc': 'Bom'},
              {'cod': '4', 'desc': 'Muito Bom'},
              {'cod': '5', 'desc': 'Excelente'},
            ].map((item) {
              return DropdownMenuItem<String>(
                value: item['cod'],
                child: Text('${item['desc']} (${item['cod']}/5)'),
              );
            }).toList(),
            onChanged: (value) => setState(() => _codAvaliacao = value ?? '3'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descAvaliacaoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descrição da Avaliação',
            ),
            maxLines: 2,
          ),
        ],
      );
    }

    final avaliacao = _getAvaliacaoTexto(widget.infraestrutura['cod_avaliacao']);
    final cod = int.tryParse(widget.infraestrutura['cod_avaliacao'] ?? '0') ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeProvider.primaryColor.withValues(alpha:0.1),
            themeProvider.primaryColor.withValues(alpha:0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.primaryColor.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  avaliacao,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.infraestrutura['desc_avaliacao'] != null)
                  Text(
                    widget.infraestrutura['desc_avaliacao'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
          Text(
            '$cod/5',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para seleção de localização no mapa
class _MapaPicker extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Function(double lat, double lng) onLocationSelected;

  const _MapaPicker({
    required this.latitude,
    required this.longitude,
    required this.onLocationSelected,
  });

  @override
  State<_MapaPicker> createState() => _MapaPickerState();
}

class _MapaPickerState extends State<_MapaPicker> {
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selecione a localização',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}, '
                'Long: ${_selectedLocation.longitude.toStringAsFixed(6)}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _selectedLocation,
                  initialZoom: 15,
                  onTap: (tapPosition, point) {
                    setState(() => _selectedLocation = point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onLocationSelected(
                  _selectedLocation.latitude,
                  _selectedLocation.longitude,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Confirmar Localização',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}