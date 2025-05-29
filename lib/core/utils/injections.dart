import 'package:get_it/get_it.dart';

import '../../data/data_sources/anniversary_local_data_source.dart';
import '../../data/repositories/anniversary_repository_impl.dart';
import '../../domain/repositories/anniversary_repository.dart';
import '../../domain/usecases/add_anniversary.dart';
import '../../domain/usecases/delete_anniversary.dart';
import '../../domain/usecases/get_all_anniversaries.dart';
import '../../domain/usecases/update_anniversary.dart';
import '../../presentation/diary/bloc/diary_bloc.dart';
import '../../shared/utils/helpers/database_helper.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  // 0) DatabaseHelper
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // 1) Data source (lúc này sl<DatabaseHelper>() đã có)
  sl.registerLazySingleton<AnniversaryLocalDataSource>(
    () => AnniversaryLocalDataSourceImpl(sl<DatabaseHelper>()),
  );

  // 2) Repository
  sl.registerLazySingleton<AnniversaryRepository>(
    () => AnniversaryRepositoryImpl(sl<AnniversaryLocalDataSource>()),
  );

  // 3) Use cases
  sl.registerLazySingleton<GetAllAnniversaries>(
    () => GetAllAnniversaries(sl<AnniversaryRepository>()),
  );
  sl.registerLazySingleton<AddAnniversary>(
    () => AddAnniversary(sl<AnniversaryRepository>()),
  );
  sl.registerLazySingleton<UpdateAnniversary>(
    () => UpdateAnniversary(sl<AnniversaryRepository>()),
  );
  sl.registerLazySingleton<DeleteAnniversary>(
    () => DeleteAnniversary(sl<AnniversaryRepository>()),
  );

  // 4) Bloc
  sl.registerFactory<DiaryBloc>(
    () => DiaryBloc(
      getAllAnniversaries: sl<GetAllAnniversaries>(),
      addAnniversary: sl<AddAnniversary>(),
      updateAnniversary: sl<UpdateAnniversary>(),
      deleteAnniversary: sl<DeleteAnniversary>(),
    ),
  );
}
