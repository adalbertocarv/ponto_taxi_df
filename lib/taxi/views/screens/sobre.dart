import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Biblioteca adicionada

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  // Estado para gerenciar a funcionalidade clicada (apenas para desktop/tablet)
  // O estado rastreia o índice do container que deve expandir e exibir a descrição completa.
  int? _selectedIndex;
  
  // Lista unificada de funcionalidades ATUALIZADA com ícones e descrições
  final List<Map<String, dynamic>> _functionalityItems = const [
    {
      'icon': Icons.map,
      'title': 'Mapa Interativo',
      'description': 'Visualização e navegação de pontos',
      'grid_title': 'Exibição de mapa interativo via flutter_map, permitindo visualização de pontos cadastrados, controle de camadas e rastreamento em tempo real.',
    },
    {
      'icon': Icons.pin_drop,
      'title': 'Cadastro via GPS',
      'description': 'Adição de pontos com precisão GPS',
      'grid_title': 'Cadastro de novos pontos utilizando a precisão do GPS para garantir a exatidão da localização, essencial para auditorias fiscais.',
    },
    {
      'icon': Icons.my_location,
      'title': 'Geolocalização',
      'description': 'Centraliza a localização do usuário',
      'grid_title': 'Recurso de geolocalização para centralizar o mapa rapidamente na posição atual do usuário e facilitar o processo de auditoria em campo.',
    },
    {
      'icon': Icons.tune,
      'title': 'Controles do Mapa',
      'description': 'Zoom, satélite e orientação',
      'grid_title': 'Controles avançados de zoom, satélite e orientação para o Norte, melhorando a exploração e a compreensão do mapa.',
    },
    {
      'icon': Icons.lock_person,
      'title': 'Login Seguro',
      'description': 'Acesso autorizado (SEMOB)',
      'grid_title': 'Autenticação segura e restrita para Auditores Fiscais da SEMOB, protegendo o acesso aos dados sensíveis e garantindo a integridade do sistema.',
    },
    {
      'icon': Icons.account_circle,
      'title': 'Gestão de Perfil',
      'description': 'Visualização e atualização de dados',
      'grid_title': 'Gestão completa do perfil do auditor, incluindo nome, e-mail e foto, com facilidade de visualização e atualização de dados pessoais.',
    },
  ];

  // --- Funções Auxiliares de Responsividade ---

  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;
  
  // --- Funções Auxiliares para Responsividade ---

  /// Retorna padding padrão baseado na largura da tela
  EdgeInsetsGeometry _getDefaultPadding(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: padding menor para aproveitar mais a tela
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 20);
    } else if (screenWidth < 900) {
      // Tablet pequeno
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 40);
    } else if (screenWidth < 1200) {
      // Tablet grande
      return const EdgeInsets.symmetric(horizontal: 50, vertical: 50);
    } else {
      // Desktop: padding original (mantido, o aumento será no tamanho dos elementos)
      return const EdgeInsets.symmetric(horizontal: 70, vertical: 60);
    }
  }

  /// Retorna largura máxima baseada na largura da tela
  double _getDefaultMaxWidth(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: usa quase toda a largura disponível
      return screenWidth * 0.95;
    } else if (screenWidth < 900) {
      // Tablet pequeno: usa 90% da largura
      return screenWidth * 0.9;
    } else if (screenWidth < 1200) {
      // Tablet grande: usa 85% da largura até 1000px
      return (screenWidth * 0.90).clamp(0, 1000);
    } else {
      // Desktop: largura máxima de 1200px (padrão original)
      return 1200;
    }
  }

  // --- Widgets de Conteúdo ---

  Widget _buildContent(BuildContext context) {
    final isDesktop = _isDesktop(context);
    final isTablet = _isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título principal responsivo
        _buildTitle(context, isDesktop, isTablet),
        const SizedBox(height: 50),

        // Descrição principal
        _buildMainDescription(),
        const SizedBox(height: 35),

        // Funcionalidades em grid responsivo
        _buildFunctionalitiesSection(context),
        
        // O painel de detalhes separado foi removido, a expansão é in-line.

        const SizedBox(height: 60),

        // Seções de equipes em layout responsivo
        _buildTeamsSection(context),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, bool isDesktop, bool isTablet) {
    // Usando AutoSizeText para garantir que o título se ajuste sem overflow
    return AutoSizeText(
      'SOBRE O APLICATIVO\nPONTO CERTO TAXI.',
      maxLines: 2,
      minFontSize: 40, // Tamanho mínimo para o texto
      style: TextStyle(
        // Define o tamanho máximo (desktop: 110, mobile/tablet: 60)
        fontSize: isDesktop ? 110 : 60,
        fontWeight: FontWeight.w900, 
        fontFamily: 'monospace',
        height: 0.9,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMainDescription() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues( alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'Ponto Certo - Táxi é um aplicativo Flutter desenvolvido para cadastrar pontos de táxi '
        'no Distrito Federal (DF), Brasil. Criado para Auditores Fiscais da Secretaria de '
        'Transporte e Mobilidade (SEMOB), ele oferece ferramentas para mapear e catalogar pontos '
        'de táxi com precisão, utilizando recursos avançados de mapa e geolocalização.  ',
        style: TextStyle(
          fontSize: 20, 
          color: Colors.black87,
          fontWeight: FontWeight.w300, 
          height: 1.5,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildFunctionalitiesSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isDesktop = _isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Principais Funcionalidades',
          style: TextStyle(
            fontSize: isDesktop ? 42 : (isMobile ? 24 : 30),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),

        // Grid responsivo de funcionalidades
        isMobile
            ? _buildFunctionalitiesList()
            : _buildFunctionalitiesGrid(context),
      ],
    );
  }

  Widget _buildFunctionalitiesList() {
    final functionalities = _functionalityItems;

    return Column(
      children: functionalities
          .map(
            (func) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0069B4).withValues( alpha:0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      func['icon'] as IconData,
                      color: const Color(0xFF0069B4),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          func['title'] as String,
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        // Mantendo a descrição curta no mobile para listas
                        Text(
                          func['description'] as String,
                          style: TextStyle(
                            fontSize: 14, 
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFunctionalitiesGrid(BuildContext context) {
    final functionalities = _functionalityItems;
    final isTablet = _isTablet(context);
    final isDesktop = _isDesktop(context);

    final iconSize = isDesktop ? 50.0 : 32.0; 
    final titleFontSize = isDesktop ? 22.0 : 20.0;
    final descFontSize = isDesktop ? 18.0 : 16.0;

    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues( alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 2 : 3,
          // Mantendo o ajuste do childAspectRatio para garantir espaço suficiente
          childAspectRatio: isDesktop ? 1.3 : 1.6, 
          crossAxisSpacing: isDesktop ? 40 : 30, 
          mainAxisSpacing: isDesktop ? 50 : 30, 
        ),
        itemCount: functionalities.length,
        itemBuilder: (context, index) {
          final func = functionalities[index];
          final isSelected = index == _selectedIndex;

          // Conteúdo do container (Title + Descrição Curta ou apenas Title)
          Widget contentWidget;
          if (isSelected) {
            // EXPANDIDO: Agora mostra o título principal e a descrição curta (description)
            contentWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  func['title'] as String,
                  style: TextStyle(
                    fontSize: titleFontSize + 4, // Título maior em destaque
                    color: const Color(0xFF0069B4),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                // Descrição Curta (description) - ALTERADO PARA USAR ESTE CAMPO
                Text(
                  func['description'] as String,
                  style: TextStyle(
                    fontSize: descFontSize,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            );
          } else {
            // NORMAL: Mostra apenas o título principal
            contentWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( 
                  func['title'] as String,
                  style: TextStyle( 
                    fontSize: titleFontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                // A descrição curta (description) foi removida aqui para atender ao pedido
              ],
            );
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                // Alterna o estado de seleção: se já estiver selecionado, deseleciona (null).
                _selectedIndex = isSelected ? null : index;
              });
            },
            // Usando AnimatedContainer para garantir transições visuais suaves
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Animação de transição
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                // Aumentando o padding vertical no estado expandido para forçar o crescimento do container
                horizontal: isSelected ? 35 : 25,
                vertical: isSelected ? 40 : 30,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0069B4).withValues( alpha:0.15)
                    : Colors.white, // Fundo branco no estado normal
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0069B4)
                      : Colors.grey.shade300, // Borda sutil no estado normal
                  width: isSelected ? 2.0 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0069B4).withValues( alpha:0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues( alpha:0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Icon( 
                    func['icon'] as IconData,
                    color: const Color(0xFF0069B4),
                    size: iconSize,
                  ),
                  const SizedBox(width: 30), 
                  Expanded(
                    child: contentWidget,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamsSection(BuildContext context) {
    // Substituindo context.isMobile pelo novo helper
    final isMobile = _isMobile(context);

    return isMobile ? _buildTeamsMobile() : _buildTeamsDesktop(context);
  }

  Widget _buildTeamsMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamCard(
          'Equipe Demandante/Organizacional',
          [
            'Ana Carolina Pereira de Araújo',
            'Gerson Antônio Silva Soares Ferreira'
          ],
          Icons.business,
        ),
        const SizedBox(height: 40),
        _buildTeamCard(
          'Equipe de Desenvolvimento',
          [
            'Adalberto Carvalho Santos Júnior',
            'Ednardo de Oliveira Ferreira',
            'Gabriel Pedro Veras',
            'Lucas Bezerra da Cruz',
          ],
          Icons.code,
        ),
      ],
    );
  }

  Widget _buildTeamsDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTeamCard(
            'Equipe Demandante/Organizacional',
            [
              'Ana Carolina Pereira de Araújo',
              'Gerson Antônio Silva Soares Ferreira'
            ],
            Icons.business,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildTeamCard(
            'Equipe de Desenvolvimento',
            [
              'Adalberto Carvalho Santos Júnior',
              'Ednardo de Oliveira Ferreira',
              'Gabriel Pedro Veras',
              'Lucas Bezerra da Cruz',
            ],
            Icons.code,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamCard(String title, List<String> members, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues( alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0069B4).withValues( alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0069B4),
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...members.map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      member,
                      style: TextStyle(
                        fontSize: 22, 
                        color: Colors.black87,
                        fontWeight: FontWeight.w500, 
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Função Build Principal ---

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsivePadding = _getDefaultPadding(screenWidth);
    final responsiveMaxWidth = _getDefaultMaxWidth(screenWidth);

    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              padding: responsivePadding,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: responsiveMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Conteúdo principal
                    _buildContent(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
