import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../start_controller.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key}); // ✅ Thêm super.key vào constructor

  @override
  Widget build(BuildContext context) {
    final StartController controller =
        Get.find(); // ✅ Chuyển vào build để tránh lỗi khởi tạo sớm

    return ElevatedButton.icon(
      onPressed: controller.startCounter,
      icon: const Icon(Icons.favorite_border, color: Colors.white),
      label: const Text(
        "Start",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        // backgroundColor: Colors.deepOrangeAccent,
        backgroundColor: Colors.cyan.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}
