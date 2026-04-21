import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/home/repository/movie_repository.dart';
import '../../features/home/cubit/home_cubit.dart';
import '../../features/search/cubit/search_cubit.dart';
import '../../features/detail/cubit/detail_cubit.dart';
import '../../features/watchlist/repository/watchlist_repository.dart';
import '../../features/watchlist/cubit/watchlist_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  ApiClient.instance.init();

  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepository(ApiClient.instance.dio),
  );
  sl.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepository(),
  );

  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<MovieRepository>()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl<MovieRepository>()));
  sl.registerFactory<DetailCubit>(() => DetailCubit(sl<MovieRepository>(), sl<WatchlistRepository>()));
  sl.registerFactory<WatchlistCubit>(() => WatchlistCubit(sl<WatchlistRepository>()));
}
