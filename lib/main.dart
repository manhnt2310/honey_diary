import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:honey_diary/presentation/home/presentation/home_page.dart';
import 'package:honey_diary/presentation/home/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/intro/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Kiem tra da vao man hinh Start lan dau chua
  bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  String? savedDateString = prefs.getString('selectedDate');

  Widget firstScreen;

  if (hasSeenIntro && savedDateString != null) {
    // Nếu đã lưu ngày, parse sang DateTime
    DateTime startDate = DateTime.parse(savedDateString);
    firstScreen = HomeScreen(startDate: startDate);
  } else {
    // Nếu chưa có ngày => show màn StartScreen
    firstScreen = const OnboardingScreen();
  }

  runApp(MyApp(firstScreen: firstScreen));
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;
  const MyApp({super.key, required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Days Counter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Lora',
        textTheme: const TextTheme(),
      ),
      home: firstScreen,
    );
  }
}
