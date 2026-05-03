import 'package:flutter/material.dart';
import '../../../shared/widgets/movie_card.dart';
import '../../home/models/movie.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<Movie> movies;
  final void Function(Movie) onMovieTap;
  final bool isLoading;
  final double cardWidth;
  final double cardHeight;

  const HorizontalMovieList({
    super.key,
    required this.movies,
    required this.onMovieTap,
    this.isLoading = false,
    this.cardWidth = 140,
    this.cardHeight = 210,
  });

  @override
  Widget build(BuildContext context) {
    // The outer SizedBox gives the list a tight height, so each card's
    // Column is fully constrained and Expanded works correctly.
    return SizedBox(
      height: cardHeight + 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: isLoading ? 6 : movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (isLoading) {
            return SizedBox(
              width: cardWidth,
              height: cardHeight + 52,
              child: const MovieCardShimmer(),
            );
          }
          final movie = movies[index];
          return SizedBox(
            width: cardWidth,
            child: MovieCard(movie: movie, onTap: () => onMovieTap(movie)),
          );
        },
      ),
    );
  }
}
