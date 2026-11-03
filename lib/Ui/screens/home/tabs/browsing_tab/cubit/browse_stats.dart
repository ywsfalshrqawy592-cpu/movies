import 'package:movies_app/api/model/movie/Movies.dart';

abstract class BrowseStats {}

// TODO: loading.
class BrowseLoadingStats extends BrowseStats {}

// TODO: loaded successfully
class BrowseSuccessStats extends BrowseStats {
  final List<Movies> moviesList;

  BrowseSuccessStats({required this.moviesList});
}

// TODO:error message.
class BrowseErrorStats extends BrowseStats {
  final String errorMessage;

  BrowseErrorStats({required this.errorMessage});
}
