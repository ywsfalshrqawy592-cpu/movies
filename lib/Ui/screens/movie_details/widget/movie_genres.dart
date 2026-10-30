import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class MovieGenres extends StatelessWidget {
  final List<String> genres;

  const MovieGenres({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Genres", style: AppStyles.bold24White),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genres.map((genre) {
              return Container(
                alignment: Alignment.center,
                width: 122,
                height: 36,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.darkFieldColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(genre, style: AppStyles.regular16White),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
