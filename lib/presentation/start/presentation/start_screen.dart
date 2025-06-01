import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/presentation/home_screen.dart';
import '../bloc/start_bloc.dart';
import '../bloc/start_state.dart';
import '../widgets/date_picker_button.dart';
import '../widgets/love_text_display.dart';
import '../widgets/start_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StartBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Choose the day you started falling in love 💖',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
              maxLines: 2,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 86, 203, 253),
                    Color.fromARGB(255, 209, 240, 255),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
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
                child: BlocListener<StartBloc, StartState>(
                  listener: (context, state) {
                    if (state is StartSuccess) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder:
                              (_) => HomeScreen(startDate: state.startDate),
                        ),
                      );
                    }
                    if (state is StartFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error: \${state.error}')),
                      );
                    }
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: AssetImage(
                          'lib/assets/image/icons8-love-100.png',
                        ),
                      ),
                      SizedBox(height: 10),
                      LoveTextDisplay(),
                      SizedBox(height: 20),
                      DatePickerButton(),
                      SizedBox(height: 20),
                      StartButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
