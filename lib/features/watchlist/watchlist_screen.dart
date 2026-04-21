import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cubit/watchlist_cubit.dart';
import 'cubit/watchlist_state.dart';
import 'models/watchlist_item.dart';
import '../../../core/constants/app_routes.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoaded && state.items.isEmpty) {
            return const _EmptyWatchlist();
          }
          if (state is WatchlistLoaded) {
            return _WatchlistBody(state: state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _WatchlistBody extends StatelessWidget {
  final WatchlistLoaded state;
  const _WatchlistBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WatchlistCubit>();
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        if (state.unwatched.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'To Watch (${state.unwatched.length})',
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: state.unwatched.length,
            itemBuilder: (context, i) => _WatchlistTile(
              item: state.unwatched[i],
              onTap: () => context.push(AppRoutes.detailPath(state.unwatched[i].id)),
              onToggleWatched: () => cubit.toggleWatched(state.unwatched[i].id),
              onRemove: () => cubit.remove(state.unwatched[i].id),
            ),
          ),
        ],
        if (state.watched.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Watched (${state.watched.length})',
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          SliverList.builder(
            itemCount: state.watched.length,
            itemBuilder: (context, i) => _WatchlistTile(
              item: state.watched[i],
              onTap: () => context.push(AppRoutes.detailPath(state.watched[i].id)),
              onToggleWatched: () => cubit.toggleWatched(state.watched[i].id),
              onRemove: () => cubit.remove(state.watched[i].id),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _WatchlistTile extends StatelessWidget {
  final WatchlistItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleWatched;
  final VoidCallback onRemove;

  const _WatchlistTile({
    required this.item,
    required this.onTap,
    required this.onToggleWatched,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key('watchlist_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade700,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.posterUrl != null
              ? CachedNetworkImage(
                  imageUrl: item.posterUrl!,
                  width: 52,
                  height: 78,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 52,
                  height: 78,
                  color: theme.cardTheme.color,
                  child: const Icon(Icons.movie_outlined, color: Colors.white24),
                ),
        ),
        title: Text(
          item.title,
          style: theme.textTheme.titleSmall?.copyWith(
            decoration: item.isWatched ? TextDecoration.lineThrough : null,
            color: item.isWatched
                ? theme.colorScheme.onSurface.withOpacity(0.4)
                : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 13),
            const SizedBox(width: 3),
            Text(
              item.voteAverage.toStringAsFixed(1),
              style: theme.textTheme.bodySmall,
            ),
            if (item.year.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(item.year, style: theme.textTheme.bodySmall),
            ],
          ],
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(
            item.isWatched
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
            color: item.isWatched
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          onPressed: onToggleWatched,
          tooltip: item.isWatched ? 'Mark as unwatched' : 'Mark as watched',
        ),
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 72,
            color: theme.colorScheme.onSurface.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          Text('Your watchlist is empty', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Add movies and shows to keep track\nof what you want to watch.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
