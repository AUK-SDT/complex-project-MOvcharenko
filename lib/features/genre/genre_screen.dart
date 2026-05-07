import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'cubit/genre_cubit.dart';
import 'cubit/genre_state.dart';
import '../models/genre.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../core/constants/app_routes.dart';

class GenreScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final genre = Genre(id: widget.genreId, name: widget.genreName);
    context.read<GenreCubit>().loadGenre(genre);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<GenreCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GenreCubit, GenreState>(
        builder: (context, state) {
          if (state is GenreLoading || state is GenreInitial) {
            return _GenreLoadingBody(genreName: widget.genreName);
          }
          if (state is GenreError) {
            return Scaffold(
              appBar: AppBar(title: Text(widget.genreName)),
              body: ErrorView(
                failure: state.failure,
                onRetry: () => context.read<GenreCubit>().retry(
                  Genre(id: widget.genreId, name: widget.genreName),
                ),
              ),
            );
          }
          if (state is GenreLoaded) {
            return _GenreLoadedBody(
              state: state,
              scrollController: _scrollController,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _GenreLoadedBody extends StatelessWidget {
  final GenreLoaded state;
  final ScrollController scrollController;

  const _GenreLoadedBody({
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: Text(state.genre.name),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${state.movies.length}${state.hasReachedEnd ? '' : '+'} titles',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.52,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final movie = state.movies[index];
                return MovieCard(
                  item: movie,
                  onTap: () => context.push(AppRoutes.detailPath(movie.id, isMovie: true)),
                );
              },
              childCount: state.movies.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _PaginationFooter(state: state),
        ),
      ],
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  final GenreLoaded state;
  const _PaginationFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.hasReachedEnd) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            "You've seen it all!",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return const SizedBox(height: 32);
  }
}

class _GenreLoadingBody extends StatelessWidget {
  final String genreName;
  const _GenreLoadingBody({required this.genreName});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: Text(genreName),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.52,
            ),
            delegate: SliverChildBuilderDelegate(
                  (_, __) => const MovieCardShimmer(),
              childCount: 12,
            ),
          ),
        ),
      ],
    );
  }
}