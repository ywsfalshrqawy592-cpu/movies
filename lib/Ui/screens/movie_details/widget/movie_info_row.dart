import 'package:flutter/material.dart';
import '../../../../utils/app_assets.dart';
import 'movie_info_item.dart';

class MovieInfoRow extends StatelessWidget {
  final String likeCount;
  final String runtime;
  final String rating;

  const MovieInfoRow({
    super.key,
    required this.likeCount,
    required this.runtime,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MovieInfoItem(
          imagePath: AppAssets.hart,
          value: likeCount,
        ),
        MovieInfoItem(
          imagePath: AppAssets.time,
          value: runtime,
        ),
        MovieInfoItem(
          imagePath: AppAssets.star,
          value: rating,
        ),
      ],
    );
  }
}