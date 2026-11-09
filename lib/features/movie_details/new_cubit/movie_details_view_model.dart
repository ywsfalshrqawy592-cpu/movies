import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/network/dio_manager.dart';

import 'movie_details_stats.dart';

part 'suggestions_view_model.dart';

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
