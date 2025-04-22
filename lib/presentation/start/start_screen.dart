import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'start_controller.dart';
import 'widgets/background_image.dart';
import 'widgets/date_picker_button.dart';
import 'widgets/love_text_display.dart';
import 'widgets/start_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StartController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Please choose the date you started falling in love 💖",
            style: TextStyle(
              fontSize: 21,
              color: Colors.pink[300],
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const BackgroundImage(), // 🌟 Hình nền
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('lib/assets/gif/icons8-love (1).gif'),
                  ),
                  SizedBox(height: 10),
                  LoveTextDisplay(), // 🌟 Hiển thị ngày yêu
                  SizedBox(height: 20),
                  DatePickerButton(), // 🌟 Nút chọn ngày
                  SizedBox(height: 20),
                  StartButton(), // 🌟 Nút bắt đầu
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
