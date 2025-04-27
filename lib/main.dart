// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:honey_diary/core/utils/injections.dart';
import 'presentation/diary/bloc/diary_bloc.dart';
import 'presentation/diary/bloc/diary_event.dart';
import 'presentation/intro/onboarding_screen.dart';
import 'presentation/home/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();

  final prefs = await SharedPreferences.getInstance();
  bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  String? savedDateStr = prefs.getString('selectedDate');

  Widget firstScreen;
  if (hasSeenIntro && savedDateStr != null) {
    firstScreen = HomeScreen(startDate: DateTime.parse(savedDateStr));
  } else {
    firstScreen = const OnboardingScreen();
  }

  runApp(
    MultiBlocProvider(
      providers: [
        // Khởi tạo AnniversaryBloc và ngay lập tức load data
        BlocProvider<DiaryBloc>(
          create: (_) => sl<DiaryBloc>()..add(LoadAnniversariesEvent()),
        ),
      ],
      child: MyApp(firstScreen: firstScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;
  const MyApp({super.key, required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Days Counter',
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Lora'),
      home: firstScreen,
    );
  }
}
