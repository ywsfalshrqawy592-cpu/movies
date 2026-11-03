import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/language_switch.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

import '../../cubit/onboarding/onboarding_cubit.dart';

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

  Future<void> _onNext(BuildContext context) async {
    final cubit = context.read<OnboardingCubit>();
    if (cubit.isLast) {
      await cubit.finish();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.homeRouteName);
    } else {
      cubit.next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      l10n.onboardingDiscoverTitle,
      l10n.onboardingGenresTitle,
      l10n.onboardingWatchlistsTitle,
      l10n.onboardingRateReviewTitle,
      l10n.onboardingStartWatchingTitle,
    ];
    final descriptions = [
      l10n.onboardingDiscoverDescription,
      l10n.onboardingGenresDescription,
      l10n.onboardingWatchlistsDescription,
      l10n.onboardingRateReviewDescription,
      '',
    ];

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
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 12, end: 16),
                child: const LanguageSwitch(),
              ),
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
                          l10n.onboardingHeroTitle,
                          textAlign: TextAlign.center,
                          style: AppStyles.bold36White,
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          l10n.onboardingHeroDescription,
                          textAlign: TextAlign.center,
                          style: AppStyles.bold20gray,
                        ),
                      ] else ...[
                        Text(
                          titles[index - 1],
                          textAlign: TextAlign.center,
                          style: AppStyles.bold36White.copyWith(fontSize: 24),
                        ),
                        if (descriptions[index - 1].isNotEmpty) ...[
                          SizedBox(height: height * 0.015),
                          Text(
                            descriptions[index - 1],
                            textAlign: TextAlign.center,
                            style: AppStyles.regular16White,
                          ),
                        ],
                      ],
                      SizedBox(height: height * 0.025),
                      CustomElevatedBotton(
                        borderColor: AppColors.primaryColor,
                        onPressed: () => _onNext(context),
                        child: Text(
                          isFirst
                              ? l10n.onboardingExplore
                              : isLast
                              ? l10n.onboardingFinish
                              : l10n.onboardingNext,
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
                          child: Text(
                            l10n.onboardingBack,
                            style: AppStyles.bold20Primary,
                          ),
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
