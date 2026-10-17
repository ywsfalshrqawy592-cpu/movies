import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/cubit/home/home_cubit.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/size_utils.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({required this.selectedIndex});

  final int selectedIndex;

  static const _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.explore_outlined,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;

    return Container(
      height: height * .065,
      margin: EdgeInsets.fromLTRB(width * .02, 0, width * .02, height * .01),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(width * .037),
      ),
      child: Row(
        children: List.generate(
          _icons.length,
              (index) => Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(width * .037),
              onTap: () => context.read<HomeCubit>().selectTab(index),
              child: Icon(
                _icons[index],
                color: selectedIndex == index
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                size: width * .06,
              ),
            ),
          ),
        ),
      ),
    );
  }
}