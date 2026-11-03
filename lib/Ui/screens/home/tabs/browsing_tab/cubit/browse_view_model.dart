import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';

import 'browse_stats.dart';

class BrowseViewModel extends Cubit<BrowseStats> {
  BrowseViewModel() : super(BrowseLoadingStats());

  // TODO: Current selected.
  String selectedGenre = 'Action';

  // TODO: Get movies.
  Future<void> getMovies(String genre) async {
    try {
      selectedGenre = genre;
      emit(BrowseLoadingStats());

      final movies = await DioManager.getMoviesByGenre(genre: genre);

      if (movies.isEmpty) {
        emit(BrowseErrorStats(errorMessage: 'No movies found'));
        return;
      }
      emit(BrowseSuccessStats(moviesList: movies));
    } catch (e) {
      emit(BrowseErrorStats(errorMessage: e.toString()));
    }
  }
}
