import 'package:movies_app/api/model/movie_details/movie_details.dart';

class MovieDetailsState {}

class MovieDetailsLoadingState extends MovieDetailsState {}

class MovieDetailsErrorState extends MovieDetailsState {
  String? statusMessage;
  MovieDetailsErrorState({required this.statusMessage});
}

class MovieDetailsSuccessState extends MovieDetailsState {
  MovieDetails? moviesList;

  MovieDetailsSuccessState({required this.moviesList});
}
