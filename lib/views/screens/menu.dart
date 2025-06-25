import 'package:flutter/material.dart';
import 'package:ponto_taxi_df/views/screens/login.dart';
import 'package:ponto_taxi_df/views/screens/perfil.dart';
import 'package:ponto_taxi_df/views/screens/sobre.dart';
import 'package:provider/provider.dart';
import '../../providers/themes/tema_provider.dart';
import '../../providers/autenticacao/auth_provider.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da página
              Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

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
                          color: themeProvider.isDarkMode
                              ? ThemeProvider.primaryColorDark
                              : ThemeProvider.primaryColor,
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
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Perfil())
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Ajuda'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navegar para ajuda
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Sobre'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Sobre()));
                      },
                    ),
                    const Divider(height: 1,),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sair'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        authProvider.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}