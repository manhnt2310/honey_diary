import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../start_controller.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final StartController controller = Get.find();

    return ElevatedButton.icon(
      onPressed: () => controller.pickDate(context),
      icon: const Icon(Icons.calendar_today, color: Colors.white),
      label: const Text("Select date", style: TextStyle(fontSize: 21)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}
