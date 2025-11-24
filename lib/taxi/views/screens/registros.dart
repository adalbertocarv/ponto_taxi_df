import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/providers/themes/tema_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controllers/modo_app_controller.dart';
import '../widgets/notificacoes.dart';
import 'detalhamento_infra.dart';

class Registros extends StatefulWidget {
  const Registros({super.key});

  @override
  State<Registros> createState() => _RegistrosState();
}

class _RegistrosState extends State<Registros> {
  List<dynamic> infraestruturas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarInfraestruturas();
  }

  Future<void> _carregarInfraestruturas() async {
    try {
      final response = await http.get(
        Uri.parse('https://lathiest-gustily-carri.ngrok-free.dev/infraestrutura/stip'),
        headers: {
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          infraestruturas = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao carregar dados: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro de conexão: $e';
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final modoApp = context.watch<ModoAppController>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, color: themeProvider.primaryColor, size: 26),
                  const SizedBox(width: 20),
                  Text(
                    'R E G I S T R O S',
                    style: TextStyle(
                      fontSize: 24,
                      color: themeProvider.primaryColor,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (errorMessage != null)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(errorMessage!, textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = null;
                                });
                                _carregarInfraestruturas();
                              },
                              child: const Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      )
                    else if (infraestruturas.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Nenhum registro hoje',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Text(
                                  'Pontos cadastrados ou em fila de envio estarão aqui disponíveis para visualização',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                              modoApp.isCadastro
                                  ? Image.asset('assets/images/bus_stop_azul.webp', height: 250)
                                  : Image.asset('assets/images/bus_stop_verde.webp', height: 250),
                            ],
                          ),
                        )
                      else
                        RefreshIndicator(
                          onRefresh: _carregarInfraestruturas,
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 32 : 8,
                              vertical: 8,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                              childAspectRatio: isDesktop ? 1.2 : 0.85,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: infraestruturas.length,
                            itemBuilder: (context, index) {
                              final infra = infraestruturas[index];
                              return _buildInfraCard(infra, themeProvider, isDesktop);
                            },
                          ),
                        ),
                    const Notificacao(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfraCard(dynamic infra, ThemeProvider themeProvider, bool isDesktop) {
    final imageUrl = _getImageUrl(infra['img_infraestrutura']);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheInfraestrutura(infraestrutura: infra),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  headers: const {
                    'ngrok-skip-browser-warning': 'true',
                  },
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[600]),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.location_on, size: 48, color: Colors.grey[600]),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTipoInfraestrutura(infra['id_tipo_infraestrutura']),
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      infra['endereco'] ?? 'Endereço não informado',
                      style: TextStyle(fontSize: isDesktop ? 13 : 12, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.local_parking, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${infra['num_vagas'] ?? 0} vagas',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        if (infra['ponto_oficial'] == true)
                          Chip(
                            label: const Text('Oficial', style: TextStyle(fontSize: 10)),
                            backgroundColor: Colors.green[100],
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}