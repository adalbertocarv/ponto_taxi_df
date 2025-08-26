import 'package:flutter/material.dart';
import 'desktop/desktop_telainicio.dart';
import 'mobile/mobile_telainicio.dart';

class TelaInicioPage extends StatelessWidget {
  const TelaInicioPage();

  static const _desktopBreakpoint = 780.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= _desktopBreakpoint) {
      return DesktopTelaInicio();
    }
    return MobileTelaInicio();
  }
}