import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../start_controller.dart';

class LoveTextDisplay extends StatelessWidget {
  const LoveTextDisplay({super.key}); // ✅ Thêm super.key vào constructor

  @override
  Widget build(BuildContext context) {
    final StartController controller =
        Get.find(); // ✅ Đưa vào build để tránh lỗi khởi tạo sớm

    return Obx(() => Text(
          controller.getFormattedDate(),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
          ),
        ));
  }
}
