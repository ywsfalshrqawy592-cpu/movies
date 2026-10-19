import 'package:flutter/material.dart';
import 'package:movies_app/models/avatar_model.dart';
import 'package:movies_app/utils/app_colors.dart';

class AvatarItem extends StatelessWidget {
  final AvatarModel avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const AvatarItem({
    super.key,
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.6)
              : AppColors.transparentColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Image.asset(avatar.image, fit: BoxFit.contain),
      ),
    );
  }
}