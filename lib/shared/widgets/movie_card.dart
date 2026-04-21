import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../features/home/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.width = 140,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PosterImage(
              url: movie.posterUrl,
              width: width,
              height: height,
              rating: movie.ratingDisplay,
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (movie.year.isNotEmpty)
              Text(
                movie.year,
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final String rating;

  const _PosterImage({
    required this.url,
    required this.width,
    required this.height,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: url != null
                ? CachedNetworkImage(
                    imageUrl: url!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _ShimmerBox(width: width, height: height),
                    errorWidget: (_, __, ___) => _PlaceholderBox(height: height),
                  )
                : _PlaceholderBox(height: height),
          ),
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
  final double height;
  const _PlaceholderBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Theme.of(context).cardTheme.color,
      child: const Center(
        child: Icon(Icons.movie_outlined, color: Colors.white24, size: 40),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
      highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: Container(width: width, height: height, color: Colors.white),
    );
  }
}

class MovieCardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const MovieCardShimmer({super.key, this.width = 140, this.height = 210});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
      highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(width: width, height: height, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(width: width * 0.8, height: 13, color: Colors.white, margin: const EdgeInsets.only(bottom: 4)),
          Container(width: width * 0.4, height: 11, color: Colors.white),
        ],
      ),
    );
  }
}
