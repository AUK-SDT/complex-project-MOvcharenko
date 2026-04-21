import 'package:flutter/material.dart';
import '../../home/models/genre.dart';

class GenreChipRow extends StatelessWidget {
  final List<Genre> genres;
  final void Function(Genre) onGenreTap;

  const GenreChipRow({
    super.key,
    required this.genres,
    required this.onGenreTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = genres[index];
          return ActionChip(
            label: Text(genre.name),
            onPressed: () => onGenreTap(genre),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }
}
