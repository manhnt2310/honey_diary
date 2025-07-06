import 'package:get_it/get_it.dart';

import '../../data/data_sources/chat_remote_data_source.dart';
import '../../data/data_sources/journal_local_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/repositories/chat_massage_repository.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/usecases/add_journal.dart';
import '../../domain/usecases/delete_journal.dart';
import '../../domain/usecases/get_all_journals.dart';
import '../../domain/usecases/send_massage.dart';
import '../../domain/usecases/update_journal.dart';
import '../../presentation/chat/bloc/chat_bloc.dart';
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

  // Chat
  // 1) Data source
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );

  // 2) Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
  );

  // 3) Use case
  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(sl<ChatRepository>()),
  );

  // 4) BLoC
  sl.registerFactory<ChatBloc>(() => ChatBloc(sl<SendMessageUseCase>()));
}
