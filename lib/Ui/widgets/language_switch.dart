import 'package:flutter/material.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_utils.dart';

/// Static EN / AR pill — English selected, as in the design (UI only).
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  Widget _flag(BuildContext context, String path, {bool selected = false}) {
    final size = context.height * 0.041;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(context.width * 0.012),
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
      width: context.width * 0.21,
      height: context.height * 0.041,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _flag(context, AppAssets.flagUs, selected: true),
          _flag(context, AppAssets.flagEg),
        ],
      ),
    );
  }
}
