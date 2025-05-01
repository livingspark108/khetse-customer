import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  int tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void navigateToHome() {
    tabIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void refreshedLocation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }
}