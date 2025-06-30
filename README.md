# Ponto Certo - Táxi
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/adalbertocarv/ponto_taxi_df)

Ponto Certo - Táxi é um aplicativo Flutter desenvolvido para cadastrar pontos de táxi no Distrito Federal (DF), Brasil. Criado para Auditores Fiscais da Secretaria de Transporte e Mobilidade (SEMOB), ele oferece ferramentas para mapear e catalogar pontos de táxi com precisão.

## ✨ Funcionalidades

- **Mapa Interativo**: Utiliza `flutter_map` para exibir um mapa interativo que facilita a navegação e o cadastro de pontos.
- **Cadastro de Pontos via GPS**: Permite adicionar novos pontos de táxi utilizando o GPS do dispositivo, posicionando um marcador central no mapa e confirmando a localização.
- **Geolocalização do Usuário**: Integra-se ao GPS do dispositivo para encontrar e centralizar a localização atual do usuário no mapa.
- **Controles Avançados do Mapa**: Controles intuitivos para zoom, orientação para o Norte, alternância entre imagem de satélite e centralização no usuário.
- **Autenticação Segura**: Sistema de login seguro para pessoal autorizado, com credenciais validadas contra o serviço backend da SEMOB.
- **Gestão de Perfil de Usuário**: Tela dedicada ao perfil que exibe informações como nome, e-mail e permite atualizar a foto de perfil.
- **Suporte a Tema Claro e Escuro**: Oferece suporte tanto para tema claro quanto escuro, visando conforto visual em diferentes condições de iluminação.
- **Navegação Personalizada**: Barra de navegação curva e botão flutuante do tipo speed-dial para uma experiência de navegação mais fluida e intuitiva.
- **Easter Egg**: Um recurso escondido onde múltiplos cliques no título do menu disparam um som e uma animação de confetes.

## 🛠️ Tecnologias Utilizadas

- **Framework**: Flutter
- **Gerenciamento de Estado**: `provider`
- **Mapeamento e Localização**: `flutter_map`, `geolocator`, `latlong2`, `vector_map_tiles`
- **Componentes de UI**: `curved_navigation_bar`, `flutter_speed_dial`, `mask_text_input_formatter`
- **Comunicação com API**: `http`
- **Armazenamento Local**: `shared_preferences` para persistência de sessão

## 🚀 Primeiros Passos

Para rodar uma cópia local do projeto, siga os passos abaixo:

### Pré-requisitos

Garanta que você tenha o [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado na sua máquina.

### Instalação

1. Clone o repositório:
    ```sh
    git clone https://github.com/adalbertocarv/ponto_taxi_df.git
    ```
2. Acesse o diretório do projeto:
    ```sh
    cd ponto_taxi_df
    ```
3. Instale as dependências:
    ```sh
    flutter pub get
    ```
4. Execute o aplicativo:
    ```sh
    flutter run
    ```

## 📂 Estrutura do Projeto

O projeto segue uma estrutura padrão do Flutter, organizada para separar responsabilidades e melhorar a manutenção.

