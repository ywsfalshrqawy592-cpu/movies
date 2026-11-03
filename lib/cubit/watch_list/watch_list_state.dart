import 'saved_movie.dart';

class WatchListState {
  const WatchListState({this.movies = const [], this.errorMessage});

  final List<SavedMovie> movies;
  final String? errorMessage;

  int get count => movies.length;

  bool isSaved(int movieId) => movies.any((movie) => movie.id == movieId);
}
