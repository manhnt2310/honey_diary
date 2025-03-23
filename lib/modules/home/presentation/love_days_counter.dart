import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';

import '/modules/diary/presentations/diary_screen.dart';

class LoveDaysCounter extends StatefulWidget {
  final DateTime startDate;

  const LoveDaysCounter({super.key, required this.startDate});

  @override
  LoveDaysCounterState createState() => LoveDaysCounterState();
}

class LoveDaysCounterState extends State<LoveDaysCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dayAnimation;
  late Animation<double> _percentAnimation;

  // Biến điều khiển nhịp đập của icon trái tim
  double _scaleFactor = 1.0;
  // Màu của icon trái tim
  Color _iconColor = Colors.pink;
  // Vòng lặp thay đổi màu trái tim
  int _colorIndex = 0;

  // Biến bật/tắt giao diện: 4 ô hay vòng tròn
  bool _showYearsMonthsDays = false;

  // Danh sách màu cho trái tim
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
    Colors.white
  ];

  // Mốc chuẩn 365 ngày để tính % hiển thị vòng tròn
  final int _cycleDays = 365;
  late int totalDays;

  // Biến hiển thị thời gian hiện tại
  late String _currentTime;
  Timer? _timeTimer; // để hủy timer khi dispose

  @override
  void initState() {
    super.initState();

    // Tính số ngày từ startDate đến hiện tại
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(widget.startDate);
    totalDays = difference.inDays;

    // Tính phần trăm cho CircularPercentIndicator
    double finalPercent = (totalDays % _cycleDays) / _cycleDays;

    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Animation số ngày (0 -> totalDays)
    _dayAnimation = IntTween(begin: 0, end: totalDays).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Animation phần trăm (0.0 -> finalPercent)
    _percentAnimation =
        Tween<double>(begin: 0.0, end: finalPercent).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    // Chạy animation
    _controller.forward();

    // Khởi chạy nhịp đập tim
    _startHeartBeatAnimation();

    // Khởi tạo và cập nhật thời gian hiện tại
    _currentTime = _getTime();
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = _getTime();
      });
    });
  }

  // Lấy giờ-phút-giây hiện tại dạng "HH:MM:SS"
  String _getTime() {
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final ss = now.second.toString().padLeft(2, '0');
    return "$hh:$mm:$ss";
  }

  // Tính hiệu ứng nhịp đập tim
  void _startHeartBeatAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _scaleFactor = _scaleFactor == 1.0 ? 1.2 : 1.0;
      });
    });
  }

  // Đổi màu trái tim
  void _changeHeartColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % _colors.length;
      _iconColor = _colors[_colorIndex];
    });
  }

  // Vuốt để chuyển giao diện
  void _toggleDateFormat() {
    setState(() {
      _showYearsMonthsDays = !_showYearsMonthsDays;
    });
  }

  // Tách số ngày thành năm, tháng, tuần, ngày
  List<int> _calculateUnits(int _) {
    DateTime now = DateTime.now();

    // Tính hiệu số lịch cho năm, tháng, ngày
    int years = now.year - widget.startDate.year;
    int months = now.month - widget.startDate.month;
    int days = now.day - widget.startDate.day;

    // Điều chỉnh nếu ngày âm (chưa đến ngày trong tháng)
    if (days < 0) {
      months -= 1;
      // Lấy số ngày của tháng trước (lưu ý: DateTime(year, month, 0) trả về ngày cuối tháng trước)
      DateTime previousMonth = DateTime(now.year, now.month, 0);
      days += previousMonth.day;
    }

    // Điều chỉnh nếu tháng âm (chưa đến tháng trong năm)
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    // Tính số tuần và số ngày còn lại từ phần "ngày" đã tính được
    int weeks = days ~/ 7;
    int remainingDays = days % 7;

    // Trả về list theo thứ tự: [năm, tháng, tuần, số ngày còn lại]
    return [years, months, weeks, remainingDays];
  }

  // Widget tạo mỗi ô hiển thị
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
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tách ngày ra 4 đơn vị
    final units =
        _calculateUnits(_dayAnimation.value); // [năm, tháng, tuần, ngày]

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút đầu tiên nằm bên trái
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiaryScreen()),
                );
              },
              icon: const Icon(Icons.menu_book_rounded),
            ),
            // Nhóm 3 nút còn lại nằm bên phải
            // Row(
            //   children: [
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.mode_edit_outline),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.camera_alt),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.settings),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (!_showYearsMonthsDays && details.primaryVelocity! < 0) {
            // Khi đang ở màn hình ban đầu (circular indicator)
            // và vuốt từ phải sang trái (primaryVelocity < 0)
            _toggleDateFormat();
          } else if (_showYearsMonthsDays && details.primaryVelocity! > 0) {
            // Khi đang ở màn hình 4 ô (years, months, weeks, days)
            // và vuốt từ trái sang phải (primaryVelocity > 0)
            _toggleDateFormat();
          } 
        },
        child: Stack(
          children: <Widget>[
            // Hình nền
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/image/mountains.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Nội dung chính
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Nếu _showYearsMonthsDays = true => hiển thị thời gian
                  // Ngược lại => hiển thị vòng tròn đếm
                  _showYearsMonthsDays
                      ? SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Hàng trên: 4 ô
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildBox(units[0], "NĂM"),
                                    const SizedBox(width: 10),
                                    _buildBox(units[1], "THÁNG"),
                                    const SizedBox(width: 10),
                                    _buildBox(units[2], "TUẦN"),
                                    const SizedBox(width: 10),
                                    _buildBox(units[3], "NGÀY"),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Hàng dưới: Ngày bắt đầu + Thời gian hiện tại
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Ngày bắt đầu
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withValues(alpha: .7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "${widget.startDate.day.toString().padLeft(2, '0')}"
                                        "/${widget.startDate.month.toString().padLeft(2, '0')}"
                                        "/${widget.startDate.year}",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),

                                    // Thời gian hiện tại
                                    Row(
                                      children:
                                          _currentTime.split(":").map((unit) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 247, 105, 152),
                                            child: Text(
                                              unit,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(125),
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          child: CircularPercentIndicator(
                            radius: 125.0,
                            lineWidth: 10.0,
                            animation: false, // Tắt animation của plugin
                            percent: _percentAnimation.value,
                            backgroundColor: Colors.white.withValues(alpha: .6),
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'đang yêu',
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
                                  'ngày',
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

                  const SizedBox(height: 90),
                  // Ảnh + Trái tim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('lib/assets/image/male.jpg'),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
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
                      const SizedBox(width: 20),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('lib/assets/image/female.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Label "Male" và "Female"
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Male',
                        style: TextStyle(fontSize: 20, color: Colors.lightBlue),
                      ),
                      SizedBox(width: 135),
                      Text(
                        'Female',
                        style:
                            TextStyle(fontSize: 20, color: Colors.pinkAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
