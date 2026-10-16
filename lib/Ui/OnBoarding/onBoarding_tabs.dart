import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

import 'onboarding_cubit.dart';

class OnboardingTabs extends StatelessWidget {
  const OnboardingTabs({super.key});

  static final List<String> imagesList = [
    AppAssets.onBoarding_1,
    AppAssets.onBoarding_2,
    AppAssets.onBoarding_3,
    AppAssets.onBoarding_4,
    AppAssets.onBoarding_5,
    AppAssets.onBoarding_6,
  ];

  static const List<String> title = [
    "Discover Movies",
    "Explore All Genres",
    "Create Watchlists",
    "Rate, Review, and Learn",
    "Start Watching Now",
  ];

  static const List<String> description = [
    "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
    "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
    "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
    "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
    "",
  ];

  Future<void> _onNext(BuildContext context) async {
    final cubit = context.read<OnboardingCubit>();
    if (cubit.isLast) {
      await cubit.finish();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
    } else {
      cubit.next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Stack(
        children: [
          BlocBuilder<OnboardingCubit, int>(
            builder: (context, index) => Image.asset(
              imagesList[index],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<OnboardingCubit, int>(
              builder: (context, index) {
                final isFirst = index == 0;
                final isLast = index == imagesList.length - 1;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(12, isFirst ? 0 : 24, 12, 40),
                  decoration: BoxDecoration(
                    color: isFirst ? Colors.transparent : AppColors.blackColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isFirst) ...[
                        Text(
                          "Find Your Next\nFavorite Movie Here",
                          textAlign: TextAlign.center,
                          style: AppStyles.bold36White,
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Get access to a huge library of movies\nto suit all tastes. You will surely like it.',
                          textAlign: TextAlign.center,
                          style: AppStyles.bold20gray,
                        ),
                      ] else ...[
                        Text(
                          title[index - 1],
                          textAlign: TextAlign.center,
                          style: AppStyles.bold36White.copyWith(fontSize: 24),
                        ),
                        if (description[index - 1].isNotEmpty) ...[
                          SizedBox(height: height * 0.015),
                          Text(
                            description[index - 1],
                            textAlign: TextAlign.center,
                            style: AppStyles.bold20gray.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                      SizedBox(height: height * 0.025),
                      CustomElevatedBotton(
                        borderColor: AppColors.primaryColor,
                        onPressed: () => _onNext(context),
                        child: Text(
                          isFirst ? 'Explore Now' : (isLast ? 'Finish' : 'Next'),
                          style: AppStyles.bold24Black,
                        ),
                      ),
                      if (index >= 2 && !isLast) ...[
                        SizedBox(height: height * 0.01),
                        CustomElevatedBotton(
                          backgroundColor: AppColors.blackColor,
                          borderColor: AppColors.primaryColor,
                          onPressed: () =>
                              context.read<OnboardingCubit>().previous(),
                          child: Text('Back', style: AppStyles.bold20Primary),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}