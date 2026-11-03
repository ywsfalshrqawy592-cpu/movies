import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class MovieInfoItem extends StatelessWidget {
  final String imagePath;
  final String value;
  final double? width;
  final double? height;
  final double? imageWidth;
  final double? imageHeight;
  final double? fontSize;

  const MovieInfoItem({
    super.key,
    required this.imagePath,
    required this.value,
    this.width,
    this.height,
    this.imageWidth = 28,
    this.imageHeight = 25,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: height ?? 47,
      width: width??110,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
          ),
          const SizedBox(width: 15),
          Text(
            value,
            style: AppStyles.bold24White,
          ),
        ],
      ),
    );
  }
}