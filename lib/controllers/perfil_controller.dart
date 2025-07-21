import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';
import '../services/perfil_service.dart';

class PerfilController extends ChangeNotifier {
  final PerfilService _service = PerfilService();
  bool isLoading = false;

  Usuario usuario = Usuario(
    nomeFuncionario: '',
    matricula: '',
    nomeCargo: '',
    nomeUnidade: '',
    codigoUnidade: '',
    nomeUnidadeSuperior: '',
    codigoUnidadeSuperior: '',
  );

  Future<void> carregarPerfil(String idUsuario) async {
    final fetchedUsuario = await _service.buscarInfoUsuario(idUsuario);
    if (fetchedUsuario != null) {
      usuario = fetchedUsuario;

      // Carrega a foto salva (se existir)
      final prefs = await SharedPreferences.getInstance();
      usuario.fotoPath = prefs.getString('fotoPath');

      notifyListeners();
    }
  }

  void alterarFoto(String path) async {
    usuario.fotoPath = path;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fotoPath', path);
  }
}
