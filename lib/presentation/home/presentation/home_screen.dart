import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:honey_diary/presentation/weather/presentation/weather_page.dart';
import '../../diary/presentations/diary_screen.dart';

class HomeScreen extends StatefulWidget {
  final DateTime startDate;

  const HomeScreen({super.key, required this.startDate});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dayAnimation;
  late Animation<double> _percentAnimation;

  late PageController _pageController;
  int _currentPage = 0;

  // Nhịp đập tim & đổi màu
  double _scaleFactor = 1.0;
  Color _iconColor = Colors.pink;
  int _colorIndex = 0;
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

  // Tính %
  final int _cycleDays = 365;
  late int totalDays;

  // Đồng hồ real‑time
  late String _currentTime;
  Timer? _timeTimer;

  // Birth date & Zodiac cho Me và You
  DateTime? _birthDateMe;
  DateTime? _birthDateYou;
  String _zodiacSignMe = "Zodiac";
  String _zodiacSignYou = "Zodiac";
  int? _ageMe;
  int? _ageYou;

  @override
  void initState() {
    super.initState();

    // Tính tổng ngày và phần trăm
    final now = DateTime.now();
    totalDays = now.difference(widget.startDate).inDays;
    double finalPercent = (totalDays % _cycleDays) / _cycleDays;

    // Animation controller cho day & percent
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _dayAnimation = IntTween(begin: 0, end: totalDays).animate(_controller)
      ..addListener(() => setState(() {}));
    _percentAnimation = Tween<double>(
      begin: 0.0,
      end: finalPercent,
    ).animate(_controller)..addListener(() => setState(() {}));
    _controller.forward();

    // Nhịp đập tim
    _startHeartBeatAnimation();

    // Đồng hồ: inline luôn lấy giờ
    _currentTime = _formatTime(DateTime.now());
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      setState(() {
        _currentTime = _formatTime(now);
      });
    });

    // PageController & listener để cập nhật indicator
    _pageController = PageController(initialPage: 0)..addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });

    _loadSavedBirthDates();
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return "$hh:$mm:$ss";
  }

  void _startHeartBeatAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _scaleFactor = _scaleFactor == 1.0 ? 1.2 : 1.0;
      });
    });
  }

  void _changeHeartColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % _colors.length;
      _iconColor = _colors[_colorIndex];
    });
  }

  List<int> _calculateUnits(int _) {
    final now = DateTime.now();
    int years = now.year - widget.startDate.year;
    int months = now.month - widget.startDate.month;
    int days = now.day - widget.startDate.day;

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

  Widget _buildBox(int value, String label) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$value",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSavedBirthDates() async {
    final prefs = await SharedPreferences.getInstance();

    final meStr = prefs.getString('birthDateMe');
    if (meStr != null) {
      final dt = DateTime.parse(meStr);
      setState(() {
        _birthDateMe = dt;
        _ageMe = _calculateAge(dt);
        _zodiacSignMe = _getZodiacSign(dt);
      });
    }

    final youStr = prefs.getString('birthDateYou');
    if (youStr != null) {
      final dt = DateTime.parse(youStr);
      setState(() {
        _birthDateYou = dt;
        _ageYou = _calculateAge(dt);
        _zodiacSignYou = _getZodiacSign(dt);
      });
    }
  }

  // Hiện bottom sheet chọn ngày sinh cho Me hoặc You
  void _showBirthDatePicker(bool isMe) {
    DateTime tempPicked =
        (isMe ? _birthDateMe : _birthDateYou) ?? DateTime(2000, 1, 1);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempPicked,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime dt) {
                    tempPicked = dt;
                  },
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final age = _calculateAge(tempPicked);
                  final zodiac = _getZodiacSign(tempPicked);

                  // Cập nhật state
                  setState(() {
                    if (isMe) {
                      _birthDateMe = tempPicked;
                      _ageMe = age;
                      _zodiacSignMe = zodiac;
                    } else {
                      _birthDateYou = tempPicked;
                      _ageYou = age;
                      _zodiacSignYou = zodiac;
                    }
                  });

                  // Lưu vào SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  final key = isMe ? 'birthDateMe' : 'birthDateYou';
                  await prefs.setString(key, tempPicked.toIso8601String());
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
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
    final d = date.day;
    final m = date.month;
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

  @override
  void dispose() {
    _controller.dispose();
    _timeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final units = _calculateUnits(_dayAnimation.value);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DiaryScreen()),
                      ),
                  icon: const Icon(Icons.menu_book_rounded),
                ),
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WeatherPage()),
                      ),
                  icon: const Icon(Icons.cloud_outlined),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_edit_outline),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/image/background.JPG'),
                fit: BoxFit.cover,
              ),
              // color: Color.fromARGB(255, 252, 198, 206),
            ),
          ),

          // Nội dung chính
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 24),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    // Trang 0: CircularPercentIndicator
                    Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(125),
                          color: Colors.white.withValues(alpha: .4),
                        ),
                        child: CircularPercentIndicator(
                          radius: 125.0,
                          lineWidth: 10.0,
                          animation: false,
                          percent: _percentAnimation.value,
                          backgroundColor: Colors.white.withValues(alpha: .6),
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'in love',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.pink,
                                ),
                              ),
                              Text(
                                _dayAnimation.value.toString(),
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'days',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.pink,
                                ),
                              ),
                            ],
                          ),
                          linearGradient: const LinearGradient(
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.lightBlue,
                              Colors.blueAccent,
                              Colors.blue,
                            ],
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),

                    // Trang 1: 4 ô years/months/weeks/days
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildBox(units[0], "YEAR"),
                                const SizedBox(width: 10),
                                _buildBox(units[1], "MONTH"),
                                const SizedBox(width: 10),
                                _buildBox(units[2], "WEEK"),
                                const SizedBox(width: 10),
                                _buildBox(units[3], "DAY"),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Ngày bắt đầu
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: .7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${widget.startDate.day.toString().padLeft(2, '0')}"
                                    "/${widget.startDate.month.toString().padLeft(2, '0')}"
                                    "/${widget.startDate.year}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Thời gian hiện tại
                                Row(
                                  children:
                                      _currentTime
                                          .split(':')
                                          .asMap()
                                          .entries
                                          .expand<Widget>((entry) {
                                            final idx = entry.key;
                                            final unit = entry.value;
                                            final avatar = Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1,
                                                  ),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                      255,
                                                      247,
                                                      105,
                                                      152,
                                                    ),
                                                child: Text(
                                                  unit,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                            if (idx <
                                                _currentTime.split(':').length -
                                                    1) {
                                              return [
                                                avatar,
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 1,
                                                  ),
                                                  child: Text(
                                                    ':',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromARGB(
                                                        255,
                                                        247,
                                                        105,
                                                        152,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ];
                                            } else {
                                              return [avatar];
                                            }
                                          })
                                          .toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    dotColor: Colors.white.withValues(alpha: .5),
                    activeDotColor: Colors.pinkAccent,
                  ),
                ),
              ),

              // Thay cho cả phần Avatar + Heart + Me/You + Zodiac/Age
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    // Cột cho "Me"
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Avatar
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'lib/assets/image/male.jpg',
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Label
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 21,
                                color: Color.fromARGB(255, 0, 88, 117),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Zodiac + Age
                          GestureDetector(
                            onTap: () => _showBirthDatePicker(true),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_ageMe != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: .6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${_ageMe!}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 0, 88, 117),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _zodiacSignMe,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Icon trái tim ở giữa
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: _changeHeartColor,
                        child: Transform.scale(
                          scale: _scaleFactor,
                          child: Icon(
                            Icons.favorite,
                            color: _iconColor,
                            size: 50.0,
                          ),
                        ),
                      ),
                    ),

                    // Cột cho "You"
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'lib/assets/image/female.jpg',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 21,
                                color: Color.fromARGB(255, 248, 89, 113),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showBirthDatePicker(false),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_ageYou != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: .6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${_ageYou!}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(
                                          255,
                                          248,
                                          89,
                                          113,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _zodiacSignYou,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ],
      ),
    );
  }
}
