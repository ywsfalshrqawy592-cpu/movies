import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import 'api_error_handler/api_error_handler.dart';
import 'model/ movie_suggestions/Movie_suggestions.dart';
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
  static Future< MovieSuggestions>getMovieSuggestions({required int sourceId,}) async {
    try {
      var detailsResponse = await dio.get(
        ApiEndPoints.movieSuggestions,
        queryParameters: {"movie_id": sourceId},
      );
      return  MovieSuggestions.fromJson(detailsResponse.data);
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    }
  }

  static Future<List<Movie>> getMovies({
    String? genre,
    int limit = 10,
    String? sortBy,
  }) async {
    try {
      final response = await dio.get(
        ApiEndPoints.listMovies,
        queryParameters: {
          'limit': limit,
          if (genre != null) 'genre': genre,
          if (sortBy != null) 'sort_by': sortBy,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        List moviesJson = response.data['data']['movies'] ?? [];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
          response.data['status_message'] ?? 'Failed to load movies',
        );
      }
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }
}
