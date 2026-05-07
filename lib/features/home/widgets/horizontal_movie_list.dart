import 'package:flutter/material.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../models/media_item.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<MediaItem> items;
  final void Function(MediaItem) onItemTap;
  final bool isLoading;
  final double cardWidth;
  final double cardHeight;

  const HorizontalMovieList({
    super.key,
    required this.items,
    required this.onItemTap,
    this.isLoading = false,
    this.cardWidth = 140,
    this.cardHeight = 210,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight + 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: isLoading ? 6 : items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (isLoading) {
            return SizedBox(
              width: cardWidth,
              height: cardHeight + 52,
              child: const MovieCardShimmer(),
            );
          }
          final item = items[index];
          return SizedBox(
            width: cardWidth,
            child: MovieCard(item: item, onTap: () => onItemTap(item)),
          );
        },
      ),
    );
  }
}
