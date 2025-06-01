import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honey_diary/core/utils/injections.dart';

import '../bloc/diary_bloc.dart';
import 'diary_view.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => DiaryBloc(
            getAllJournals: sl(),
            addJournal: sl(),
            updateJournal: sl(),
            deleteJournal: sl(),
          ),
      child: const DiaryView(),
    );
  }
}
