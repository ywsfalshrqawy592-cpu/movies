import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0);

  static const tabsCount = 4;

  void selectTab(int index) {
    if (index < 0 || index >= tabsCount || index == state) return;
    emit(index);
  }
}
