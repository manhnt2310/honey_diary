import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../home/presentation/love_days_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> startCounter() async {
    if (selectedDate.value != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'selectedDate',
        selectedDate.value!.toIso8601String(),
      );
      await prefs.setBool('hasSeenIntro', true);

      Get.off(() => LoveDaysCounter(startDate: selectedDate.value!));
    }
  }

  String getFormattedDate() {
    return selectedDate.value == null
        ? "Choose a love date ❤️"
        : "Love day: ${DateFormat('dd/MM/yyyy').format(selectedDate.value!)}";
  }
}
