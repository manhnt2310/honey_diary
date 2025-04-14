import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  final DateTime startDate;

  const HomePage({super.key, required this.startDate});

  @override
  Widget build(BuildContext context) {
    print("HomePage.build()");
    return BlocProvider(
      create: (_) => HomeBloc()..add(HomeInitialized(startDate)),
      child: const HomeView(),
    );
  }
}
