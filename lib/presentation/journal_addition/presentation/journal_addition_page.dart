import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honey_diary/domain/entities/journal.dart';

import '../bloc/journal_addition_bloc.dart';
import '../bloc/journal_addition_event.dart';
import 'journal_addition_view.dart';

class JournalAdditionPage extends StatelessWidget {
  final Journal? journal;
  const JournalAdditionPage({super.key, this.journal});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              JournalAdditionBloc()..add(InitializeJournalAddition(journal)),
      child: const JournalAdditionView(),
    );
  }
}
