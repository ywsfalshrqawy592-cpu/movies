import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/utils/app_prefs.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  static const int pagesCount = 6;

  bool get isLast => state == pagesCount - 1;

  void next() {
    if (state < pagesCount - 1) emit(state + 1);
  }

  void previous() {
    if (state > 0) emit(state - 1);
  }

  Future<void> finish() => AppPrefs.setOnboardingSeen();
}