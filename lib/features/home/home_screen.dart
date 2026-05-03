import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/hero_banner.dart';
import 'widgets/horizontal_movie_list.dart';
import 'widgets/content_tab_selector.dart';
import 'widgets/genre_chip_row.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../core/constants/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const _LoadingBody();
          }
          if (state is HomeError) {
            return ErrorView(
              failure: state.failure,
              onRetry: () => context.read<HomeCubit>().retry(),
            );
          }
          if (state is HomeLoaded) {
            return _LoadedBody(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final HomeLoaded state;
  const _LoadedBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final movies = state.activeList;
    final featured = movies.isNotEmpty ? movies.first : null;

    return RefreshIndicator(
      onRefresh: cubit.retry,
      child: CustomScrollView(
        slivers: [
          _HomeAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (featured != null)
                  HeroBanner(
                    movie: featured,
                    onTap: () => context.push(AppRoutes.detailPath(featured.id)),
                  ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ContentTabSelector(
                    activeTab: state.activeTab,
                    onTabChanged: cubit.switchTab,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(
                    title: state.activeTab == HomeTab.movies
                        ? 'Trending Movies'
                        : 'Popular TV Shows',
                  ),
                ),
                const SizedBox(height: 12),
                HorizontalMovieList(
                  movies: movies.skip(1).toList(),
                  onMovieTap: (m) => context.push(AppRoutes.detailPath(m.id)),
                ),
                const SizedBox(height: 28),
                if (state.genres.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SectionHeader(
                      title: 'Browse by Genre',
                      actionLabel: 'See all',
                      onAction: () {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  GenreChipRow(
                    genres: state.genres,
                    onGenreTap: (g) => context.push(AppRoutes.genrePath(g.id, g.name)),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      floating: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Cine',
              style: theme.appBarTheme.titleTextStyle,
            ),
            TextSpan(
              text: 'Log',
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => context.push(AppRoutes.search),
          tooltip: 'Search',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}