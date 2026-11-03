import '../../../../../../api/model/movie/Movies.dart';

abstract class HomeStats {}

class HomeLoadingStats extends HomeStats {}

class HomeSuccessStats extends HomeStats {
  final List<Movies> moviesList;

  HomeSuccessStats({required this.moviesList});
}

class HomeErrorStats extends HomeStats {
  final String errorMessage;

  HomeErrorStats({required this.errorMessage});
}