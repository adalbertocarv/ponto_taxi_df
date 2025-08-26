import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/perfil_controller.dart';
import '../../providers/themes/tema_provider.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('userId');
      if (idUsuario != null) {
        await context.read<PerfilController>().carregarPerfil(idUsuario.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final perfilController = context.watch<PerfilController>();
    final usuario = perfilController.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card do perfil principal
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _deveMostrarShimmer(perfilController, usuario)
                        ? _widgetPerfilShimmer(themeProvider)
                        : _widgetConteudoPerfil(themeProvider, perfilController, usuario, context),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Card de informações
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações do Funcionário',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      _deveMostrarShimmer(perfilController, usuario)
                          ? _infoShimmer()
                          : _infoConteudo(usuario, context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card de opções (sempre visível)
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add_chart),
                      title: const Text('Pontos Cadastrados'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Gerar Relatório'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Botão para tentar carregar novamente (só aparece quando há erro ou sem dados)
              if (_deveMostrarRetryButton(perfilController, usuario))
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final idUsuario = prefs.getInt('userId');
                      if (idUsuario != null) {
                        await context.read<PerfilController>().carregarPerfil(idUsuario.toString());
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para determinar se deve mostrar o shimmer
  bool _deveMostrarShimmer(PerfilController perfilController, dynamic usuario) {
    // Mostra shimmer se estiver carregando OU se não há dados do usuário
    return perfilController.isLoading || usuario == null || !_temDadosVaslidos(usuario);
  }

  // Método para verificar se os dados do usuário são válidos
  bool _temDadosVaslidos(dynamic usuario) {
    return usuario != null &&
        usuario.nomeFuncionario != null &&
        usuario.nomeFuncionario.isNotEmpty &&
        usuario.matricula != null &&
        usuario.matricula.isNotEmpty;
  }

  // Método para determinar se deve mostrar o botão "Tentar Novamente"
  bool _deveMostrarRetryButton(PerfilController perfilController, dynamic usuario) {
    // Mostra o botão apenas quando não está carregando E não há dados válidos
    return !perfilController.isLoading &&
        (usuario == null || !_temDadosVaslidos(usuario));
  }

  // Conteúdo do perfil quando carregado
  Widget _widgetConteudoPerfil(ThemeProvider themeProvider, PerfilController perfilController,
      dynamic usuario, BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: themeProvider.primaryColor,
              backgroundImage: usuario.fotoPath != null && usuario.fotoPath.isNotEmpty
                  ? FileImage(File(usuario.fotoPath!))
                  : null,
              child: (usuario.fotoPath == null || usuario.fotoPath.isEmpty)
                  ? const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              )
                  : null,
            ),
            Container(
              decoration: BoxDecoration(
                color: themeProvider.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    perfilController.alterarFoto(pickedFile.path);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Foto alterada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          usuario.nomeFuncionario ?? 'Nome não disponível',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Matrícula: ${usuario.matricula ?? 'N/A'}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Shimmer para o perfil principal
  Widget _widgetPerfilShimmer(ThemeProvider themeProvider) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Avatar shimmer
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nome shimmer
          Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // Matrícula shimmer
          Container(
            width: 150,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // Conteúdo das informações quando carregado
  Widget _infoConteudo(dynamic usuario, BuildContext context) {
    return Column(
      children: [
        _infoTile(Icons.person, 'Nome', usuario.nomeFuncionario ?? 'N/A', context),
        const SizedBox(height: 12),
        _infoTile(Icons.badge, 'Matrícula', (usuario.matricula ?? '').trim(), context),
        const SizedBox(height: 12),
        _infoTile(Icons.work, 'Cargo', usuario.nomeCargo ?? 'N/A', context),
        const SizedBox(height: 12),
        _infoTile(Icons.apartment, 'Unidade', usuario.nomeUnidade ?? 'N/A', context),
        const SizedBox(height: 12),
        _infoTile(Icons.local_post_office, 'Código Unidade', usuario.codigoUnidade ?? 'N/A', context),
        const SizedBox(height: 12),
        _infoTile(Icons.account_tree, 'Unidade Superior', usuario.nomeUnidadeSuperior ?? 'N/A', context),
        const SizedBox(height: 12),
        _infoTile(Icons.co_present, 'Código Unidade Superior', usuario.codigoUnidadeSuperior ?? 'N/A', context),
      ],
    );
  }

  // Shimmer para as informações
  Widget _infoShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(7, (index) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Widget _infoTile(
      IconData icon, String label, String value, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? 'N/A' : value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}