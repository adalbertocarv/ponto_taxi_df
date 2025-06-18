import 'package:flutter/material.dart';
import '../models/usuario_model.dart';

class PerfilController extends ChangeNotifier {
  UsuarioModel _usuario = UsuarioModel(
    nome: 'João Silva',
    email: 'joao.silva@email.com',
    telefone: '(61) 99999-9999',
    fotoPath: null,
  );

  UsuarioModel get usuario => _usuario;

  void alterarFoto(String path) {
    _usuario = _usuario.copyWith(fotoPath: path);
    notifyListeners();
  }
}
