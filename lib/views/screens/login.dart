import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponto_taxi_df/views/screens/selecao_modo_app.dart';
import 'package:provider/provider.dart';
import '../../providers/autenticacao/auth_provider.dart';
import '../../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  DateTime? _lastClickTime;
  static const int _debounceTimeMs = 1000;

  bool _shouldProcessClick() {
    final now = DateTime.now();
    if (_isLoading) return false;
    if (_lastClickTime != null) {
      final timeSinceLastClick = now.difference(_lastClickTime!).inMilliseconds;
      if (timeSinceLastClick < _debounceTimeMs) return false;
    }
    _lastClickTime = now;
    return true;
  }

  void _login() async {
    if (!_shouldProcessClick()) return;

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final senha = _senhaController.text.trim();

    if (username.isEmpty || senha.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(context, 'Por favor, preencha todos os campos.', Colors.orange);
      return;
    }

    try {
      final result = await LoginService.login(username, senha);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        _showSnackBar(context, 'Autenticado com sucesso!', Colors.green);

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectionScreen()),
        );
      } else {
        final errorMessage = result['error'] ?? 'Erro desconhecido';
        Color errorColor = Colors.red;

        if (errorMessage.contains('conexão') ||
            errorMessage.contains('internet') ||
            errorMessage.contains('Tempo limite')) {
          errorColor = Colors.orange;
        } else if (errorMessage.contains('Servidor') ||
            errorMessage.contains('indisponível')) {
          errorColor = Colors.purple;
        }

        _showSnackBar(context, errorMessage, errorColor);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      _showSnackBar(context, 'Erro inesperado. Tente novamente.', Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    if (!mounted) return;

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();

    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIconForMessage(message),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: _getDurationForMessage(message)),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: message.contains('sucesso')
            ? null
            : SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            scaffold.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  IconData _getIconForMessage(String message) {
    if (message.contains('sucesso')) return Icons.check_circle;
    if (message.contains('conexão') || message.contains('internet')) return Icons.wifi_off;
    if (message.contains('Tempo limite')) return Icons.timer_off;
    if (message.contains('Servidor') || message.contains('indisponível')) return Icons.cloud_off;
    return Icons.error;
  }

  int _getDurationForMessage(String message) {
    if (message.contains('sucesso')) return 2;
    if (message.contains('Servidor') || message.contains('Muitas tentativas')) return 5;
    return 4;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    /// o ThemeProvider
    /// não afetem esta tela
    final fixedTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        surface: Colors.white,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[200],
    );

    return Theme(
      data: fixedTheme,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Image.asset('assets/images/imagessemob.webp'),
                  const SizedBox(height: 20),
                  const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Nome de usuário', _usernameController, false),
                  const SizedBox(height: 20),
                  _buildTextField('Senha', _senhaController, true),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _buildLoginButton(authProvider),
                  const SizedBox(height: 10),
                  if (authProvider.errorMessage != null)
                    Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      bool isPassword, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        color: Colors.black, // força o texto digitado a ser preto
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black, // força o label a ser preto também
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
      ),
    );
  }


  Widget _buildLoginButton(AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLoading ? Colors.grey : Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: _isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text(
        'Entrar',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
