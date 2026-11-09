part of 'movie_details_view_model.dart';

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
