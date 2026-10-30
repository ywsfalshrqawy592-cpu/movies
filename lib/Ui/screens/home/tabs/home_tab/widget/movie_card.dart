import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class MovieCard extends StatelessWidget {
  final String imagePath;
  final num rating;
  final double? widthCard;
  final double? heightCard;

  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.onTap,
    this.widthCard,this.heightCard
  });

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: widthCard ,
        height:heightCard ,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(width * 0.04),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.fill,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
            ),

            Positioned(
              top: height * 0.016,
              right: width * 0.035,
              child: Container(
                height: height * 0.037,
                padding: EdgeInsets.symmetric(horizontal: width * 0.013),
                decoration: BoxDecoration(
                  color: AppColors.blackColor71,
                  borderRadius: BorderRadius.circular(width * 0.025),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.star,
                      width: width * 0.037,
                      height: height * 0.018,
                    ),
                    SizedBox(width: width * 0.01),
                    Text('$rating', style: AppStyles.regular16White),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
