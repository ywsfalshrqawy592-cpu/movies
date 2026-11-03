import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';


import 'home_stats.dart';

class HomeViewModel extends Cubit<HomeStats> {
  HomeViewModel() : super(HomeLoadingStats());

  Future<void> getMovies() async {
    try {
      emit(HomeLoadingStats());

      final movies = await DioManager.getMovies();

      if (movies.isEmpty) {
        emit(HomeErrorStats(errorMessage: 'No movies found'));
        return;
      }
      emit(HomeSuccessStats(moviesList: movies));

    } catch (e) {
      emit(HomeErrorStats(errorMessage: e.toString()));
    }
  }
}