import 'package:flutter/material.dart';
import 'package:movies_app/Ui/widgets/app_network_image.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

/// Poster card with a rating badge. Reusable in any movie grid/list.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.posterUrl,
    required this.rating,
    this.onTap,
  });

  final String posterUrl;
  final double rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: posterUrl, borderRadius: 16),
          PositionedDirectional(
            top: context.height * 0.01,
            start: context.width * 0.02,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.02,
                vertical: context.height * 0.004,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.withAlpha(180),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$rating', style: AppStyles.bold14White),
                  SizedBox(width: context.width * 0.01),
                  Icon(
                    Icons.star,
                    color: AppColors.primaryColor,
                    size: context.width * 0.04,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}