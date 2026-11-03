import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/dio_manager.dart';
import 'details_stats.dart';

class DetailsViewModel extends Cubit<DetailsStats> {
  DetailsViewModel() : super(MovieDetailsInitial());

  Future<void> getMovieDetailsBySourceId({required int sourceId}) async {
    try {
      emit(MovieDetailsLoading());
      final details = await DioManager.getMovieDetailsBySourceId(
        sourceId: sourceId,
      );

      if (details.status == 'error') {
        emit(
          MovieDetailsError(
            errorMessage: details.error ?? 'Something went wrong',
          ),
        );
        return;
      }
      if (details.status == 'ok') {
        final movie = details.data!;
        emit(MovieDetailsSuccess(movie: movie));
        return;
      }
    } catch (e) {
      emit(MovieDetailsError(errorMessage: e.toString()));
    }
  }
}

class SuggestionsViewModel extends Cubit<SuggestionsStats> {
  SuggestionsViewModel() : super(MovieSuggestionsInitial());

  Future<void> getMovieSuggestions({required int sourceId}) async {
    try {
      emit(MovieSuggestionsLoading());

      final suggestions = await DioManager.getMovieSuggestions(
        sourceId: sourceId,
      );

      if (suggestions.status == 'error') {
        emit(
          MovieSuggestionsError(
            errorMessage: suggestions.statusMessage ?? 'Something went wrong',
          ),
        );
        return;
      }
      if (suggestions.status == 'ok') {
        final data = suggestions.data;
        emit(MovieSuggestionsSuccess(movies: data!.movies ?? []));
        return;
      }
    } catch (e) {
      emit(MovieSuggestionsError(errorMessage: e.toString()));
    }
  }
}