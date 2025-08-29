import 'package:flutter/material.dart';

class TelaInicioController {
  int pageIndex;
  PageController? pageController; // Nullable para desktop
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final bool isDesktop;

  TelaInicioController({
    this.pageIndex = 1,
    this.isDesktop = false,
  }) {
    // Só cria PageController se não for desktop
    if (!isDesktop) {
      pageController = PageController(initialPage: pageIndex);
    }
  }

  void onNavTap(int index, Function updateState) {
    if (index == 1) {
      if (pageIndex == 1) {
        isDialOpen.value = !isDialOpen.value;
      } else {
        _navigateToPage(index);
        pageIndex = index;
        updateState();
      }
    } else {
      _navigateToPage(index);
      pageIndex = index;
      updateState();
      if (isDialOpen.value) {
        isDialOpen.value = false;
      }
    }
  }

  void _navigateToPage(int index) {
    // Só usa PageController se não for desktop
    if (!isDesktop && pageController != null) {
      pageController!.jumpToPage(index);
    }
    // Para desktop, apenas atualiza o pageIndex
    // O IndexedStack será atualizado via updateState()
  }

  void dispose() {
    isDialOpen.dispose();
    pageController?.dispose();
  }
}