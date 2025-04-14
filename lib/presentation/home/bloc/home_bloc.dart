import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const _cycleDays = 365;
  final List<Color> _colors = [
    Colors.pink,
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.brown,
    Colors.black,
    Colors.white,
  ];

  Timer? _timeTimer;
  Timer? _heartbeatTimer;
  int _colorIndex = 0;

  HomeBloc() : super(HomeState.initial()) {
    on<HomeInitialized>(_onInitialized);
    on<HeartbeatTicked>(_onHeartbeatTicked);
    on<HeartColorChanged>(_onHeartColorChanged);
    on<TimeUpdated>(_onTimeUpdated);
    on<PageChanged>(_onPageChanged);
    on<BirthDatePicked>(_onBirthDatePicked);
  }

  Future<void> _onInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    final now = DateTime.now();
    final totalDays = now.difference(event.startDate).inDays;
    final percent = (totalDays % _cycleDays) / _cycleDays;
    final units = _calculateUnits(event.startDate, now);

    // load saved birth dates
    final prefs = await SharedPreferences.getInstance();
    DateTime? bMe, bYou;
    int? ageMe, ageYou;
    String zMe = "Zodiac", zYou = "Zodiac";

    final meStr = prefs.getString('birthDateMe');
    if (meStr != null) {
      bMe = DateTime.parse(meStr);
      ageMe = _calculateAge(bMe);
      zMe = _getZodiacSign(bMe);
    }
    final youStr = prefs.getString('birthDateYou');
    if (youStr != null) {
      bYou = DateTime.parse(youStr);
      ageYou = _calculateAge(bYou);
      zYou = _getZodiacSign(bYou);
    }

    emit(
      state.copyWith(
        totalDays: totalDays,
        percent: percent,
        units: units,
        birthDateMe: bMe,
        birthDateYou: bYou,
        ageMe: ageMe,
        ageYou: ageYou,
        zodiacSignMe: zMe,
        zodiacSignYou: zYou,
      ),
    );

    // start timers
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final formatted = _formatTime(DateTime.now());
      add(TimeUpdated(formatted));
    });
    _heartbeatTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      add(HeartbeatTicked());
    });
  }

  void _onHeartbeatTicked(HeartbeatTicked event, Emitter<HomeState> emit) {
    final newScale = state.scaleFactor == 1.0 ? 1.2 : 1.0;
    emit(state.copyWith(scaleFactor: newScale));
  }

  void _onHeartColorChanged(HeartColorChanged event, Emitter<HomeState> emit) {
    _colorIndex = (_colorIndex + 1) % _colors.length;
    emit(state.copyWith(iconColor: _colors[_colorIndex]));
  }

  void _onTimeUpdated(TimeUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentTime: event.currentTime));
  }

  void _onPageChanged(PageChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentPage: event.page));
  }

  Future<void> _onBirthDatePicked(
    BirthDatePicked event,
    Emitter<HomeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = event.isMe ? 'birthDateMe' : 'birthDateYou';
    await prefs.setString(key, event.date.toIso8601String());

    final age = _calculateAge(event.date);
    final zodiac = _getZodiacSign(event.date);

    if (event.isMe) {
      emit(
        state.copyWith(
          birthDateMe: event.date,
          ageMe: age,
          zodiacSignMe: zodiac,
        ),
      );
    } else {
      emit(
        state.copyWith(
          birthDateYou: event.date,
          ageYou: age,
          zodiacSignYou: zodiac,
        ),
      );
    }
  }

  List<int> _calculateUnits(DateTime start, DateTime now) {
    int years = now.year - start.year;
    int months = now.month - start.month;
    int days = now.day - start.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    int weeks = days ~/ 7;
    int remainingDays = days % 7;
    return [years, months, weeks, remainingDays];
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String _getZodiacSign(DateTime date) {
    final d = date.day, m = date.month;
    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return "Aries";
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return "Taurus";
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return "Gemini";
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return "Cancer";
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return "Leo";
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return "Virgo";
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return "Libra";
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return "Scorpio";
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return "Sagittarius";
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return "Capricorn";
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return "Aquarius";
    return "Pisces";
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return "$hh:$mm:$ss";
  }

  @override
  Future<void> close() {
    _timeTimer?.cancel();
    _heartbeatTimer?.cancel();
    return super.close();
  }
}
