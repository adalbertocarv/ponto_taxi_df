import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/perfil_controller.dart';
import '../../providers/themes/tema_provider.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

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
                              backgroundColor: themeProvider.isDarkMode
                                  ? ThemeProvider.primaryColorDark
                                  : ThemeProvider.primaryColor,
                              backgroundImage: usuario.fotoPath != null
                                  ? AssetImage(usuario.fotoPath!)
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
                                color: themeProvider.isDarkMode
                                    ? ThemeProvider.primaryColorDark
                                    : ThemeProvider.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  perfilController
                                      .alterarFoto('assets/images/profile.jpg');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('Foto alterada com sucesso!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          usuario.nome,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          usuario.email,
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Pessoais',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      _infoTile(Icons.person, 'Nome', usuario.nome, context),
                      const SizedBox(height: 12),
                      _infoTile(Icons.email, 'Email', usuario.email, context),
                      const SizedBox(height: 12),
                      _infoTile(
                          Icons.phone, 'Telefone', usuario.telefone, context),
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
