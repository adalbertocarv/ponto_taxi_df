import 'package:flutter/material.dart';

class TelaInicioController {
  int pageIndex;
  late final PageController pageController;
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  TelaInicioController({this.pageIndex = 1}) {
    pageController = PageController(initialPage: pageIndex);
  }
  void onNavTap(int index, Function updateState) {
    if (index == 1) {
      if (pageIndex == 1) {
        isDialOpen.value = !isDialOpen.value;
      } else {
        pageController.jumpToPage(index);
        pageIndex = index;
        updateState();
      }
    } else {
      pageController.jumpToPage(index);
      pageIndex = index;
      updateState();
      if (isDialOpen.value) {
        isDialOpen.value = false;
      }
    }
  }

  void dispose() {
    isDialOpen.dispose();
    pageController.dispose();
  }
}
