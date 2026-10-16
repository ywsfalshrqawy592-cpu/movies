import 'package:flutter/material.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';

/// Static EN / AR pill — English selected, as in the design (UI only).
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  Widget _flag(String path, {bool selected = false}) {
    return Container(
      width: 38,
      height: 38,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primaryColor : AppColors.transparentColor,
      ),
      child: ClipOval(child: Image.asset(path, fit: BoxFit.cover)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 91,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _flag(AppAssets.flagUs, selected: true),
          _flag(AppAssets.flagEg),
        ],
      ),
    );
  }
}
