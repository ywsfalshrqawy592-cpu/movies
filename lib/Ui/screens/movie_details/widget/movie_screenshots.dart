import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';

class MovieScreenshots extends StatelessWidget {
  final String backgroundImage;
  final String backgroundImageOriginal;

  const MovieScreenshots({
    super.key,
    required this.backgroundImage,
    required this.backgroundImageOriginal,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Screen Shots",
            style: AppStyles.bold24White,
          ),
        ),

        SizedBox(height: height * .016),

        _buildImage(backgroundImageOriginal),

        SizedBox(height: height * .013),

        _buildImage(backgroundImage),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.white,
        ),
      ),
    );
  }
}