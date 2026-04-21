import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'cubit/search_cubit.dart';
import 'cubit/search_state.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../../core/constants/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: cubit.onQueryChanged,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Search movies & TV shows…',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            suffixIcon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, value, __) => value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        _controller.clear();
                        cubit.clear();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) return const _SearchHint();
          if (state is SearchLoading) return const _SearchShimmer();
          if (state is SearchEmpty) return _EmptyResult(query: state.query);
          if (state is SearchError) {
            return Center(
              child: Text(state.failure.message, style: theme.textTheme.bodyMedium),
            );
          }
          if (state is SearchLoaded) {
            return _ResultGrid(
              state: state,
              onTap: (id) => context.push(AppRoutes.detailPath(id)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ResultGrid extends StatelessWidget {
  final SearchLoaded state;
  final void Function(int) onTap;

  const _ResultGrid({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            '${state.results.length} results for "${state.query}"',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.55,
            ),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final movie = state.results[index];
              return MovieCard(
                movie: movie,
                onTap: () => onTap(movie.id),
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchShimmer extends StatelessWidget {
  const _SearchShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: 9,
      itemBuilder: (_, __) => const MovieCardShimmer(width: double.infinity, height: double.infinity),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          Text('Search for movies or shows', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final String query;
  const _EmptyResult({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          Text('No results for "$query"', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
