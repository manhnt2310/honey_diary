import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../diary/presentations/diary_screen.dart';
import '../../weather/presentation/weather_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dayAnimation;
  late Animation<double> _percentAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    super.initState();

    // 1) Tạo controller mặc định (0→0) để tránh late-init errors
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _dayAnimation = IntTween(begin: 0, end: 0).animate(_controller)
      ..addListener(() => setState(() {}));
    _percentAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(_controller)
      ..addListener(() => setState(() {}));
    _controller.forward();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showBirthDatePicker(bool isMe, DateTime? initial) {
    DateTime tempPicked = initial ?? DateTime(2000, 1, 1);
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
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<HomeBloc>().add(
                    BirthDatePicked(isMe, tempPicked),
                  );
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
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
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      // Chỉ listen khi totalDays hoặc percent thực sự thay đổi (lần đầu tiên)
      listenWhen:
          (prev, curr) =>
              prev.totalDays != curr.totalDays || prev.percent != curr.percent,
      listener: (context, state) {
        // Dispose controller cũ, khởi animation mới 0→totalDays
        _controller.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 5),
        );
        _dayAnimation = IntTween(
          begin: 0,
          end: state.totalDays,
        ).animate(_controller)..addListener(() => setState(() {}));
        _percentAnimation = Tween<double>(
          begin: 0.0,
          end: state.percent,
        ).animate(_controller)..addListener(() => setState(() {}));
        _controller.forward();
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, s) {
          final units = s.units;
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
                              MaterialPageRoute(
                                builder: (_) => const DiaryScreen(),
                              ),
                            ),
                        icon: const Icon(Icons.menu_book_rounded),
                      ),
                      IconButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WeatherPage(),
                              ),
                            ),
                        icon: const Icon(Icons.cloud_outlined),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mode_edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                // background
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/image/mountains.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 24),
                    Expanded(
                      child: PageView(
                        controller:
                            _pageController..addListener(() {
                              final next = _pageController.page!.round();
                              if (s.currentPage != next) {
                                context.read<HomeBloc>().add(PageChanged(next));
                              }
                            }),
                        children: [
                          // page 0
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
                                backgroundColor: Colors.white.withValues(
                                  alpha: 6,
                                ),
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
                          // page 1
                          SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ngày bắt đầu
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(
                                            alpha: .7,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          "${DateTime.now().difference(DateTime.now().subtract(Duration(days: s.totalDays))).inDays}"
                                          "/${DateTime.now().month.toString().padLeft(2, '0')}"
                                          "/${DateTime.now().year}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // thời gian hiện tại
                                      Row(
                                        children:
                                            s.currentTime
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
                                                      s.currentTime
                                                              .split(':')
                                                              .length -
                                                          1) {
                                                    return [
                                                      avatar,
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 1,
                                                            ),
                                                        child: Text(
                                                          ':',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Color.fromARGB(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          // ME
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                    'lib/assets/image/male.jpg',
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
                                    'Male',
                                    style: TextStyle(
                                      fontSize: 21,
                                      color: Color.fromARGB(255, 3, 125, 165),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap:
                                      () => _showBirthDatePicker(
                                        true,
                                        s.birthDateMe,
                                      ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (s.ageMe != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: .6,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            "${s.ageMe}",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
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
                                          color: Colors.white.withValues(
                                            alpha: .6,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          s.zodiacSignMe,
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
                          // HEART
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GestureDetector(
                              onTap:
                                  () => context.read<HomeBloc>().add(
                                    HeartColorChanged(),
                                  ),
                              child: Transform.scale(
                                scale: s.scaleFactor,
                                child: Icon(
                                  Icons.favorite,
                                  color: s.iconColor,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ),
                          // YOU
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
                                      color: Color.fromARGB(255, 246, 104, 125),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap:
                                      () => _showBirthDatePicker(
                                        false,
                                        s.birthDateYou,
                                      ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (s.ageYou != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: .6,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            "${s.ageYou}",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
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
                                          color: Colors.white.withValues(
                                            alpha: .6,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          s.zodiacSignYou,
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
        },
      ),
    );
  }
}
