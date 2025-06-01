import 'package:get_it/get_it.dart';

import '../../data/data_sources/journal_local_data_source.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/usecases/add_journal.dart';
import '../../domain/usecases/delete_journal.dart';
import '../../domain/usecases/get_all_journals.dart';
import '../../domain/usecases/update_journal.dart';
import '../../presentation/diary/bloc/diary_bloc.dart';
import '../../shared/utils/helpers/database_helper.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  // 0) DatabaseHelper
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // 1) Data source (lúc này sl<DatabaseHelper>() đã có)
  sl.registerLazySingleton<JournalLocalDataSource>(
    () => JournalLocalDataSourceImpl(sl<DatabaseHelper>()),
  );

  // 2) Repository
  sl.registerLazySingleton<JournalRepository>(
    () => JournalRepositoryImpl(sl<JournalLocalDataSource>()),
  );

  // 3) Use cases
  sl.registerLazySingleton<GetAllJournals>(
    () => GetAllJournals(sl<JournalRepository>()),
  );
  sl.registerLazySingleton<AddJournal>(
    () => AddJournal(sl<JournalRepository>()),
  );
  sl.registerLazySingleton<UpdateJournal>(
    () => UpdateJournal(sl<JournalRepository>()),
  );
  sl.registerLazySingleton<DeleteJournal>(
    () => DeleteJournal(sl<JournalRepository>()),
  );

  // 4) Bloc
  sl.registerFactory<DiaryBloc>(
    () => DiaryBloc(
      getAllJournals: sl<GetAllJournals>(),
      addJournal: sl<AddJournal>(),
      updateJournal: sl<UpdateJournal>(),
      deleteJournal: sl<DeleteJournal>(),
    ),
  );
}
