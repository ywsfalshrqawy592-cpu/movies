import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedCarouselCubit extends Cubit<int> {
  FeaturedCarouselCubit() : super(0);

  static const moviesCount = 5;

  void selectMovie(int index) {
    if (index < 0 || index >= moviesCount || index == state) return;
    emit(index);
  }
}
