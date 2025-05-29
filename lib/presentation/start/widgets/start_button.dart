import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/start_bloc.dart';
import '../bloc/start_event.dart';
import '../bloc/start_state.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartBloc, StartState>(
      builder: (context, state) {
        final isEnabled = state is StartInitial && state.selectedDate != null;
        return ElevatedButton.icon(
          onPressed:
              isEnabled
                  ? () => context.read<StartBloc>().add(const StartPressed())
                  : null,
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          label: const Text(
            'Start',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        );
      },
    );
  }
}
