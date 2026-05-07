import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../features/models/media_item.dart';

class MovieCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _PosterImage(
              url: item.posterUrl,
              rating: item.ratingDisplay,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: theme.textTheme.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.year.isNotEmpty)
            Text(item.year, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String? url;
  final String rating;

  const _PosterImage({required this.url, required this.rating});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          url != null
              ? CachedNetworkImage(
                  imageUrl: url!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const _ShimmerBox(),
                  errorWidget: (_, __, ___) => const _PlaceholderBox(),
                )
              : const _PlaceholderBox(),
          Positioned(
            bottom: 8,
            left: 8,
            child: _RatingBadge(rating: rating),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final String rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 12),
          const SizedBox(width: 3),
          Text(
            rating,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  const _PlaceholderBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardTheme.color,
      child: const Center(
        child: Icon(Icons.movie_outlined, color: Colors.white24, size: 40),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: Container(color: Colors.white),
    );
  }
}

class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
                height: 13,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 4)),
          ),
          FractionallySizedBox(
            widthFactor: 0.4,
            child: Container(height: 11, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
