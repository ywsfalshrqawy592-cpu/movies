import 'package:flutter/material.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/widget/movie_card.dart';
import 'package:movies_app/api/model/movie/Movies.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/size_utils.dart';

class BrowseMoviesGrid extends StatelessWidget {
  final List<Movies> movies;

  const BrowseMoviesGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    // TODO: Display movies in a two column
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(width * .037, 16, width * .037, 100),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .037,
        mainAxisSpacing: width * .037,
        childAspectRatio: 0.67,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];

        return MovieCard(
          imagePath: movie.mediumCoverImage ?? '',
          rating: movie.rating?.toDouble() ?? 0.0,
          // TODO: Navigate to details using the movie ID.
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.detailsRouteName,
              arguments: movie.id,
            );
          },
        );
      },
    );
  }
}
