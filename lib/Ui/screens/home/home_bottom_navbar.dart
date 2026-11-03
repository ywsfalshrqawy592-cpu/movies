import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/cubit/home/home_cubit.dart';
import 'package:movies_app/utils/app_colors.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({super.key, required this.selectedIndex});

  final int selectedIndex;

  static const _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.explore_outlined,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .28),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          _icons.length,
          (index) => Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.read<HomeCubit>().selectTab(index),
              child: Icon(
                _icons[index],
                color: selectedIndex == index
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
