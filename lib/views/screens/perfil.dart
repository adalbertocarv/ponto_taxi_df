import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      }});
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
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: themeProvider.primaryColor,
                              backgroundImage: usuario.fotoPath != null
                                  ? FileImage(File(usuario.fotoPath!)) // agora usa FileImage
                                  : null,
                              child: usuario.fotoPath == null
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
                          usuario.nomeFuncionario,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Matrícula: ${usuario.matricula}'
                          ,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Informações
              // substitua a Card de Informações
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
                      _infoTile(Icons.person, 'Nome', usuario.nomeFuncionario, context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.badge, 'Matrícula', usuario.matricula.trim(), context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.work, 'Cargo', usuario.nomeCargo, context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.apartment, 'Unidade', usuario.nomeUnidade, context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.local_post_office, 'Código Unidade', usuario.codigoUnidade, context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.account_tree, 'Unidade Superior', usuario.nomeUnidadeSuperior, context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.co_present, 'Código Unidade Superior', usuario.codigoUnidadeSuperior, context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Opções
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
            ],
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
                value,
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
