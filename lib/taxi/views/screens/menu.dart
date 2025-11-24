import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/taxi/views/screens/ajuda.dart';
import 'package:ponto_taxi_df/taxi/views/screens/login.dart';
import 'package:ponto_taxi_df/taxi/views/screens/perfil.dart';
import 'package:ponto_taxi_df/taxi/views/screens/sobre.dart';
import 'package:provider/provider.dart';
import '../../controllers/modo_app_controller.dart';
import '../../providers/themes/tema_provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../widgets/confirmacao_modo_app.dart';
import '../widgets/multi_clique.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = Provider.of<AuthProvider>(context);
    final modoApp = context.watch<ModoAppController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da página
                MultiClickAudioButton(
                  text: 'Menu',
                  audioAssetPath: 'outros/audio.mp3', // Caminho do áudio
                  requiredClicks: 5,
                  resetDelay: Duration(seconds: 3),
                  textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 24),
          
                // Card com opção de tema
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aparência',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 16),
          
                        // Switch para alternar tema
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Tema Escuro'),
                          subtitle: Text(
                            themeProvider.isDarkMode
                                ? 'Modo escuro ativado'
                                : 'Modo claro ativado',
                          ),
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                          secondary: Icon(
                            themeProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: themeProvider.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
                const SizedBox(height: 16),
          
                // Outros itens do menu
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Perfil'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Perfil()));
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Ajuda'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Ajuda()));
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.app_shortcut),
                        title: const Text('Sobre'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Sobre()));
                        },
                      ),
                      const Divider(height: 1),
                      // ListTile para mudança de modo com diálogo de confirmação
                      ListTile(
                          leading: Icon(
                            modoApp.isCadastro
                                ? Icons.assignment_turned_in_rounded
                                : Icons.add_home,
                            color: themeProvider.primaryColor,
                          ),
                          title: Text(
                            modoApp.isCadastro
                                ? 'Mudar para Modo Vistoria'
                                : 'Mudar para Modo Cadastro',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.swap_horiz),
                          onTap: () {
                            // Exibe o diálogo de confirmação quando o item for tocado
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmacaoDialog(
                                    modoApp: modoApp,
                                    themeProvider: themeProvider,
                                  );
                                });
                          }),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Sair'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          authProvider.logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
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
}
