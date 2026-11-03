import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';

import '../../../../api/model/movie_details/movie_details.dart';
import '../../home/tabs/home_tab/widget/movie_card.dart';

class SimilarMovies extends StatelessWidget {
  final List<MovieDetails> movies;
  final void Function(MovieDetails movie) onMovieTap;

  const SimilarMovies({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Similar",
          style: AppStyles.bold24White,
        ),
        SizedBox(height: height * .016),
        SizedBox(
          height: height * .25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return MovieCard(
                widthCard: 146,
                heightCard: 220,
                imagePath: movie.mediumCoverImage ?? '',
                rating: movie.rating?.toDouble() ?? 0.0,
                onTap: () => onMovieTap(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}