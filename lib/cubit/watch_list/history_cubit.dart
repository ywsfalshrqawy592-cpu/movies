import 'saved_movie.dart';
import 'watch_list_cubit.dart';

class HistoryCubit extends WatchListCubit {
  HistoryCubit(super.service, {required super.userIds});

  final maxMovies = 20;

  @override
  Future<void> add(SavedMovie movie) async {
    final movies = state.movies;
    if (!state.isSaved(movie.id) && movies.length >= maxMovies) {
      await remove(movies.last);
    }
    await super.add(movie);
  }
}
