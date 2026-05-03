import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'cubit/detail_cubit.dart';
import 'cubit/detail_state.dart';
import '../models/movie.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/constants/app_routes.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DetailCubit>().loadDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading || state is DetailInitial) {
            return const _DetailLoading();
          }
          if (state is DetailError) {
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                failure: state.failure,
                onRetry: () => context.read<DetailCubit>().loadDetail(widget.movieId),
              ),
            );
          }
          if (state is DetailLoaded) {
            return _DetailBody(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final DetailLoaded state;
  const _DetailBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final movie = state.movie;
    final theme = Theme.of(context);
    final cubit = context.read<DetailCubit>();

    return CustomScrollView(
      slivers: [
        _DetailAppBar(movie: movie, state: state, cubit: cubit),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MetaRow(movie: movie),
                const SizedBox(height: 20),
                _ActionRow(state: state, cubit: cubit),
                if (movie.overview != null && movie.overview!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Overview', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(movie.overview!, style: theme.textTheme.bodyLarge),
                ],
                if (state.similar.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  SectionHeader(title: 'More Like This'),
                  const SizedBox(height: 12),
                  _SimilarRow(movies: state.similar),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final Movie movie;
  final DetailLoaded state;
  final DetailCubit cubit;

  const _DetailAppBar({
    required this.movie,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            state.isInWatchlist ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: state.isInWatchlist ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: cubit.toggleWatchlist,
          tooltip: state.isInWatchlist ? 'Remove from watchlist' : 'Add to watchlist',
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: movie.backdropUrl != null
            ? CachedNetworkImage(
                imageUrl: movie.backdropUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: Theme.of(context).cardTheme.color,
                ),
              )
            : Container(color: Theme.of(context).cardTheme.color),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Movie movie;
  const _MetaRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: theme.textTheme.displayMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          children: [
            if (movie.year.isNotEmpty)
              _MetaChip(icon: Icons.calendar_today_outlined, label: movie.year),
            _MetaChip(
              icon: Icons.star_rounded,
              label: movie.ratingDisplay,
              iconColor: const Color(0xFFFFB800),
            ),
            _MetaChip(
              icon: movie.isMovie ? Icons.movie_outlined : Icons.tv_outlined,
              label: movie.isMovie ? 'Movie' : 'TV Show',
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _MetaChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final DetailLoaded state;
  final DetailCubit cubit;

  const _ActionRow({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: cubit.toggleWatchlist,
            icon: Icon(
              state.isInWatchlist ? Icons.check_rounded : Icons.add_rounded,
              size: 18,
            ),
            label: Text(state.isInWatchlist ? 'In Watchlist' : 'Add to Watchlist'),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: null, // Trailer feature — coming soon
          icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
          label: const Text('Trailer'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}

class _SimilarRow extends StatelessWidget {
  final List<Movie> movies;
  const _SimilarRow({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 262,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return SizedBox(
            width: 120,
            child: MovieCard(
              movie: movie,
              onTap: () => context.push(AppRoutes.detailPath(movie.id)),
            ),
          );
        },
      ),
    );
  }
}

class _DetailLoading extends StatelessWidget {
  const _DetailLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
