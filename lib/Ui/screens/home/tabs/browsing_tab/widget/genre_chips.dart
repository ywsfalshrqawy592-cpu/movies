import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class GenreChips extends StatelessWidget {
  final String selectedGenre;
  final ValueChanged<String> onGenreTap;

  const GenreChips({
    super.key,
    required this.selectedGenre,
    required this.onGenreTap,
  });

  // todo: دي الأنواع اللي هتظهر فوق، والاسم لازم يبقى زي ما الـ API فاهمه
  static const List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Sport',
    'Thriller',
    'War',
    'Western',
  ];

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: width * .037),
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        separatorBuilder: (context, index) => SizedBox(width: width * .025),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = genre == selectedGenre;

          return GestureDetector(
            onTap: () => onGenreTap(genre),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.transparentColor,
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                genre,
                style: isSelected
                    ? AppStyles.regular16Black
                    : AppStyles.regular16Primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
