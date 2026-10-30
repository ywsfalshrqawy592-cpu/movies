import '../../../../api/model/movie_details/movie_details.dart';
import '../../../../api/model/movie_details/movie_details_data.dart';


//todo Movie Details States
abstract class DetailsStats {}

class MovieDetailsInitial extends DetailsStats {}

class MovieDetailsLoading extends DetailsStats {}

class MovieDetailsSuccess extends DetailsStats {
  final MovieDetailsData movie;

  MovieDetailsSuccess({required this.movie});
}

class MovieDetailsError extends DetailsStats {
  final String errorMessage;

  MovieDetailsError({required this.errorMessage});
}

//todo Movie Suggestions States
abstract class SuggestionsStats {}

class MovieSuggestionsInitial extends SuggestionsStats {}

class MovieSuggestionsLoading extends SuggestionsStats {}

class MovieSuggestionsSuccess extends SuggestionsStats {
  final List<MovieDetails> movies;

  MovieSuggestionsSuccess({required this.movies});
}

class MovieSuggestionsError extends SuggestionsStats {
  final String errorMessage;

  MovieSuggestionsError({required this.errorMessage});
}