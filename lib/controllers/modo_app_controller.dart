import 'package:flutter/material.dart';

enum ModoApp { cadastro, vistoria }

class ModoAppController extends ChangeNotifier {
  ModoApp _modoSelecionado = ModoApp.cadastro;

  ModoApp get modoSelecionado => _modoSelecionado;

  bool get isCadastro => _modoSelecionado == ModoApp.cadastro;
  bool get isVistoria => _modoSelecionado == ModoApp.vistoria;

  void selecionarModoCadastro() {
    _modoSelecionado = ModoApp.cadastro;
    notifyListeners();
  }

  void selecionarModoVistoria() {
    _modoSelecionado = ModoApp.vistoria;
    notifyListeners();
  }
}