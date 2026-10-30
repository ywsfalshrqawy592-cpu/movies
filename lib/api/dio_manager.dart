import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_error_handler/api_error_handler.dart';
import 'model/ movie_suggestions/Movie_suggestions.dart';
import 'model/movie/Movies.dart';
import 'model/movie/Movies_list_model.dart';
import 'model/movie/movie.dart';
import 'model/movie_details/Details_response.dart';
import 'start_point_constants/api_constants.dart';
import 'start_point_constants/api_end_points.dart';

class DioManager {
  // TODO: Implement the DioManager singleton instance initialization.
  DioManager._();

  static DioManager? _instance;

  static DioManager getInstance() {
    _instance ??= DioManager._();
    return _instance!;
  }

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            receiveTimeout: Duration(seconds: 3),
            connectTimeout: Duration(seconds: 5),
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            maxWidth: 90,
            enabled: kDebugMode,
          ),
        );

  //todo https://movies-api.accel.li/api/v2/movie_details.json?movie_id=1
  static Future<DetailsResponse> getMovieDetailsBySourceId({required int sourceId,}) async {
    try {
      var detailsResponse = await dio.get(
        ApiConstants.movieDetails,
        queryParameters: {"movie_id": sourceId},
      );
      return DetailsResponse.fromJson(detailsResponse.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    }
  }

  //todo https://movies-api.accel.li/api/v2/movie_suggestions.json?movie_i=10
  static Future<MovieSuggestions> getMovieSuggestions({required int sourceId}) async {
    try {
      var detailsResponse = await dio.get(
        ApiEndPoints.movieSuggestions,
        queryParameters: {"movie_id": sourceId},
      );
      return MovieSuggestions.fromJson(detailsResponse.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    }
  }

  // TODO https://movies-api.accel.li/api/v2/list_movies.json?sort_by=year&order_by=desc&limit=15
  static Future<List<Movies>> getMovies() async {
    try {
      final response = await dio.get(
        ApiEndPoints.listMovies,
        queryParameters: {
          'sort_by': 'year',
          'order_by': 'desc',
          'limit': 15,
        },
      );

      final result = MoviesListModel.fromJson(response.data);

      return result.data?.movies ?? [];
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }












// TODO: Test Movie Details API.
// TODO: Verify movie details fields (title, language, id, year, url, genres, slug).

// TODO: Test Movie Suggestions API.
// TODO: Verify suggestions count and movies list.

// TODO: Test Movies List API.
// TODO: Verify movies count and movie fields (title, language, mpaRating, torrents, synopsis, cover image).
  static Future<void> testMovies() async {
    try {
      final result = await DioManager.getMovies();

      print('========== Movies List ==========');
      print('Movies Count: ${result.length}');

      if (result.isNotEmpty) {
        for (final movie in result) {
          print('----------------------------');
          print('Year: ${movie.year}');
          print('Title: ${movie.title}');
          print('Language: ${movie.language}');
          print('MPA Rating: ${movie.mpaRating}');
          print('Torrents: ${movie.torrents}');
          print('Synopsis: ${movie.synopsis}');
          print('Cover: ${movie.mediumCoverImage}');
        }
      } else {
        print('No Movies Found');
      }
    } catch (e) {
      print('Movies List Test Failed: $e');
    }
  }
  static Future<void> testMovieDetails() async {
    try {
      final result = await DioManager.getMovieDetailsBySourceId(
        sourceId: 15,
      );

      final movie = result.data!.movie!;

      print('========== Movie Details ==========');
      print('Title: ${movie.title}');
      print('Language: ${movie.language}');
      print('ID: ${movie.id}');
      print('Year: ${movie.year}');
      print('URL: ${movie.url}');
      print('Genres: ${movie.genres}');
      print('Slug: ${movie.slug}');
    } catch (e) {
      print('Movie Details Test Failed: $e');
    }
  }
  static Future<void> testMovieSuggestions() async {
    try {
      final result = await DioManager.getMovieSuggestions(
        sourceId: 10,
      );

      final data = result.data!;

      print('========== Movie Suggestions ==========');
      print('Movie Count: ${data.movieCount}');
      print('Suggestions Length: ${data.movies?.length}');
      print('Suggestions: ${data.movies}');

      if (data.movies != null && data.movies!.isNotEmpty) {
        print('First Suggestion: ${data.movies!.first.title}');
      }
    } catch (e) {
      print('Movie Suggestions Test Failed: $e');
    }
  }


}
