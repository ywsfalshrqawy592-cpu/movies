import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/cubit/language/language_cubit.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/size_utils.dart';

/// Switches the app language and indicates which locale is active.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  Widget _option(
    BuildContext context, {
    required String languageCode,
    required String asset,
    required String label,
    required bool selected,
  }) {
    final size = context.height * 0.041;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () =>
              context.read<LanguageCubit>().changeLanguage(languageCode),
          child: Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(context.width * 0.012),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.transparentColor,
            ),
            child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) => Container(
        width: context.width * 0.21,
        height: context.height * 0.041,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _option(
              context,
              languageCode: 'en',
              asset: AppAssets.flagUs,
              label: l10n.languageEnglish,
              selected: locale.languageCode == 'en',
            ),
            _option(
              context,
              languageCode: 'ar',
              asset: AppAssets.flagEg,
              label: l10n.languageArabic,
              selected: locale.languageCode == 'ar',
            ),
          ],
        ),
      ),
    );
  }
}
