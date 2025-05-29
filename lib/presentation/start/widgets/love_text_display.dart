import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/start_bloc.dart';
import '../bloc/start_state.dart';

/// Display widget showing either a prompt or the formatted love date
class LoveTextDisplay extends StatelessWidget {
  const LoveTextDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartBloc, StartState>(
      builder: (context, state) {
        final date = state is StartInitial ? state.selectedDate : null;
        final text =
            date == null
                ? 'Choose your love day'
                : 'Love day: ${DateFormat('dd/MM/yyyy').format(date)}';
        return Text(
          text,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
          ),
        );
      },
    );
  }
}
