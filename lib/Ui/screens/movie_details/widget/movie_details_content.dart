import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

import '../../../../api/model/movie_details/movie_details.dart';
import '../../../widgets/custom_elevated_botton.dart';
import 'movie_info_row.dart';
import 'movie_screenshots.dart';

class MovieDetailsContent extends StatelessWidget {
  final MovieDetails details;
 final VoidCallback onPressedWatch;

  const MovieDetailsContent({
    super.key,
    required this.details,
    required this.onPressedWatch
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * .016,
      ),
      child: Column(
        children: [
          SizedBox(height: height * .5),
          Text(
            textAlign: TextAlign.center,
            details.titleLong ?? "",
            style: AppStyles.bold24White,
          ),
          SizedBox(height: height * .04),
          SizedBox(
            width: double.infinity,
            height: height * .058,
            child: CustomElevatedBotton(
              backgroundColor: AppColors.redColor,
              onPressed:onPressedWatch,
              child: Text(
                "Watch",
                style: AppStyles.bold20White,
              ),
            ),
          ),
          SizedBox(height: height * .016),
          MovieInfoRow(
            likeCount: '${details.likeCount ?? 0}',
            runtime: '${details.runtime ?? 0}',
            rating: '${details.rating ?? 0}',
          ),
          MovieScreenshots(
            backgroundImageOriginal:
            details.backgroundImageOriginal ?? '',
            backgroundImage: details.backgroundImage ?? '',
          ),
        ],
      ),
    );
  }
}