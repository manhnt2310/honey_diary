import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../start/presentation/start_screen.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// Update current index when page scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  /// Update current index and Jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.offAll(() => const StartScreen());
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(builder: (context) => const StartScreen()),
      // );
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Update current index and Jump to the last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
