import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/utils/app_prefs.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale(AppPrefs.languageCode));

  Future<void> changeLanguage(String newLanguage) async {
    if (newLanguage == state.languageCode) return;
    await AppPrefs.setLanguageCode(newLanguage);
    emit(Locale(newLanguage));
  }
}