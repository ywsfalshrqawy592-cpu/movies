import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'movie_card.dart';

class LatestMoviesCarousel<T> extends StatelessWidget {
  final List<T> movies;
  final String Function(T movie) imagePath;
  final num Function(T movie) rating;
  final String Function(T movie) title;
  final double height;
  final double viewportFraction;
  final Function(int index, CarouselPageChangedReason reason)? onPageChanged;
  final ValueChanged<T>? onMovieTap;

  const LatestMoviesCarousel({
    super.key,
    required this.movies,
    required this.imagePath,
    required this.rating,
    required this.title,
    required this.height,
    this.viewportFraction = 0.55,
    this.onPageChanged,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: viewportFraction,
        height: height,
        onPageChanged: onPageChanged,
      ),
      items: movies.map((movie) {
        return MovieCard(
          imagePath: imagePath(movie),
          rating: rating(movie),
          onTap: () => onMovieTap?.call(movie),
        );
      }).toList(),
    );
  }
}


