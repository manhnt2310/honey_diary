import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeState extends Equatable {
  final int totalDays;
  final double percent;
  final double scaleFactor;
  final Color iconColor;
  final String currentTime;
  final int currentPage;
  final List<int> units; // [years, months, weeks, days]
  final DateTime? birthDateMe;
  final DateTime? birthDateYou;
  final String zodiacSignMe;
  final String zodiacSignYou;
  final int? ageMe;
  final int? ageYou;

  const HomeState({
    required this.totalDays,
    required this.percent,
    required this.scaleFactor,
    required this.iconColor,
    required this.currentTime,
    required this.currentPage,
    required this.units,
    required this.birthDateMe,
    required this.birthDateYou,
    required this.zodiacSignMe,
    required this.zodiacSignYou,
    required this.ageMe,
    required this.ageYou,
  });

  factory HomeState.initial() {
    return const HomeState(
      totalDays: 0,
      percent: 0.0,
      scaleFactor: 1.0,
      iconColor: Colors.pink,
      currentTime: "00:00:00",
      currentPage: 0,
      units: [0, 0, 0, 0],
      birthDateMe: null,
      birthDateYou: null,
      zodiacSignMe: "Zodiac",
      zodiacSignYou: "Zodiac",
      ageMe: null,
      ageYou: null,
    );
  }

  HomeState copyWith({
    int? totalDays,
    double? percent,
    double? scaleFactor,
    Color? iconColor,
    String? currentTime,
    int? currentPage,
    List<int>? units,
    DateTime? birthDateMe,
    DateTime? birthDateYou,
    String? zodiacSignMe,
    String? zodiacSignYou,
    int? ageMe,
    int? ageYou,
  }) {
    return HomeState(
      totalDays: totalDays ?? this.totalDays,
      percent: percent ?? this.percent,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      iconColor: iconColor ?? this.iconColor,
      currentTime: currentTime ?? this.currentTime,
      currentPage: currentPage ?? this.currentPage,
      units: units ?? this.units,
      birthDateMe: birthDateMe ?? this.birthDateMe,
      birthDateYou: birthDateYou ?? this.birthDateYou,
      zodiacSignMe: zodiacSignMe ?? this.zodiacSignMe,
      zodiacSignYou: zodiacSignYou ?? this.zodiacSignYou,
      ageMe: ageMe ?? this.ageMe,
      ageYou: ageYou ?? this.ageYou,
    );
  }

  @override
  List<Object?> get props => [
    totalDays,
    percent,
    scaleFactor,
    iconColor,
    currentTime,
    currentPage,
    units,
    birthDateMe,
    birthDateYou,
    zodiacSignMe,
    zodiacSignYou,
    ageMe,
    ageYou,
  ];
}
