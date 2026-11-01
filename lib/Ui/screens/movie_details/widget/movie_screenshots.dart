
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';

import '../../../../api/model/movie_details/movie_details.dart';

class MovieScreenshots extends StatelessWidget {
  final MovieDetails movieScreenshots;

  const MovieScreenshots({
    super.key,
    required this.movieScreenshots,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final screenshots = movieScreenshots.screenshots ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Screen Shots",
          style: AppStyles.bold24White,
        ),
        SizedBox(height: height * .016),
        if (screenshots.isEmpty)
          const Text(
            "No screenshots available",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        else
          ...List.generate(
            screenshots.length,
                (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: screenshots[index],
                  width: double.infinity,
                  height: 165,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
