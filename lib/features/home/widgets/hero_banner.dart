import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../models/media_item.dart';

class HeroBanner extends StatelessWidget {
  final MediaItem item;
  final VoidCallback onTap;

  const HeroBanner({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 260,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.backdropUrl != null)
              CachedNetworkImage(
                imageUrl: item.backdropUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const MovieCardShimmer(),
                errorWidget: (_, __, ___) =>
                    Container(color: theme.cardTheme.color),
              )
            else
              Container(color: theme.cardTheme.color),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark
                        ? Colors.black.withOpacity(0.9)
                        : Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TypeBadge(isMovie: item.isMovie),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFB800), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item.ratingDisplay,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.year.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Text(
                          item.year,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                      const Spacer(),
                      _WatchButton(onTap: onTap),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final bool isMovie;
  const _TypeBadge({required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isMovie ? 'MOVIE' : 'TV SHOW',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _WatchButton extends StatelessWidget {
  final VoidCallback onTap;
  const _WatchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.play_arrow_rounded, size: 16),
      label: const Text('Details', style: TextStyle(fontSize: 13)),
    );
  }
}
