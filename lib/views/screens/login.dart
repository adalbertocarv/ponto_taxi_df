import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../../providers/autenticacao/auth_provider.dart';
import '../../services/login_service.dart';
import 'telainicio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();
  bool _isLoading = false;

  final _matriculaFormatter = MaskTextInputFormatter(
    mask: '###.###-#',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Funcao para o lgoin
  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final nome = _nomeController.text.trim();
    final matricula = _matriculaFormatter.getUnmaskedText();

    final result = await LoginService.login(nome, matricula);

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true && result['idUsuario'] != null) {
      _showSnackBar(context, 'Autenticado com sucesso!', Colors.green);

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaInicio()),
        );
      });
    } else if (result['error'] == 'Timeout') {
      _showSnackBar(
        context,
        'Tempo limite. Verifique sua conexão.',
        Colors.orange,
      );
    } else {
      _showSnackBar(
        context,
        'Login falhou. Verifique suas credenciais.',
        Colors.red,
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField('Nome completo', _nomeController, false),
                const SizedBox(height: 20),
                _buildTextField(
                  'Matrícula',
                  _matriculaController,
                  false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_matriculaFormatter],
                ),
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
      obscureText: isPassword,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

        final success = await authProvider.login(
          _nomeController.text.trim(),
          _matriculaFormatter.getUnmaskedText(),
        );

        setState(() {
          _isLoading = false;
        });

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TelaInicio()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: const Text(
        'Entrar',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
