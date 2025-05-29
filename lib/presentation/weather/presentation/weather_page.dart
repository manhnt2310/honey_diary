import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService(
    '01caf1bb2f9a38b0f6df9497a204b2ea',
  );
  Weather? _weather;
  String? _errorMessage;

  // Biến lưu thời gian hiện tại dạng chuỗi
  String _currentTime = '';

  // Biến lưu Timer
  Timer? _timer;

  // Hàm fetch dữ liệu thời tiết
  Future<void> _fetchWeather() async {
    try {
      // Lấy tên thành phố hiện tại từ service
      String cityName = await _weatherService.getCurrentCity();
      // Lấy dữ liệu thời tiết cho thành phố đó
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  // Hàm trả về file animation dựa trên điều kiện thời tiết
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'lib/assets/json/null.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'lib/assets/json/cloud.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'lib/assets/json/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'lib/assets/json/rain.json';
      case 'thunderstorm':
        return 'lib/assets/json/thunder.json';
      case 'clear':
        return 'lib/assets/json/sun.json';
      default:
        return 'lib/assets/json/default.json';
    }
  }

  // Hàm cập nhật thời gian hiện tại
  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    // Cập nhật thời gian ngay khi khởi tạo
    _updateTime();

    // Thiết lập Timer cập nhật thời gian mỗi giây
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    // Huỷ Timer để tránh gọi setState() sau khi widget đã disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 76, 201, 255),
              Color.fromARGB(255, 209, 240, 255),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child:
              _errorMessage != null
                  ? Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.black),
                  )
                  : _weather == null
                  ? const CircularProgressIndicator()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tên thành phố
                      Text(
                        _weather!.cityName,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      // Hiển thị thời gian hiện tại
                      Text(
                        _currentTime,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      // Animation thời tiết
                      Lottie.asset(
                        getWeatherAnimation(_weather!.mainCondition),
                        width: 200,
                        height: 200,
                      ),
                      // Nhiệt độ
                      Text(
                        '${_weather!.temperature.round()}℃',
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.black,
                        ),
                      ),
                      // Mô tả thời tiết
                      Text(
                        _weather!.mainCondition,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
