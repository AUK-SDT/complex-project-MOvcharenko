import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_routes.dart';
import 'core/utils/service_locator.dart';
import 'features/home/home_screen.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/search/search_screen.dart';
import 'features/search/cubit/search_cubit.dart';
import 'features/detail/detail_screen.dart';
import 'features/detail/cubit/detail_cubit.dart';
import 'features/watchlist/watchlist_screen.dart';
import 'features/watchlist/cubit/watchlist_cubit.dart';
import 'features/genre/genre_screen.dart';
import 'features/genre/cubit/genre_cubit.dart';
import 'shell_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.watchlist,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<WatchlistCubit>(),
            child: const WatchlistScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<SearchCubit>(),
        child: const SearchScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.detail,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final isMovie = state.uri.queryParameters['type'] != 'tv';
        return BlocProvider(
          create: (_) => sl<DetailCubit>(),
          child: DetailScreen(mediaId: id, isMovie: isMovie),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.genre,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final name = state.uri.queryParameters['name'] ?? '';
        return BlocProvider(
          create: (_) => sl<GenreCubit>(),
          child: GenreScreen(genreId: id, genreName: name),
        );
      },
    ),
  ],
);
