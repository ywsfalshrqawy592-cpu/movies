import 'package:movies_app/Ui/screens/movie_details/movie_details_model.dart';
import 'package:movies_app/utils/app_assets.dart';

/// A movie that can be found from the search screen.
///
/// The branch does not have a movie API yet, so the catalog below is local.
/// The screen is still data-driven: replacing [searchCatalog] with a
/// repository result is enough to connect a real data source later.
class SearchMovie {
  const SearchMovie({
    required this.title,
    required this.year,
    required this.posterAsset,
    required this.rating,
    required this.genres,
    required this.collection,
  });

  final String title;
  final int year;
  final String posterAsset;
  final double rating;
  final List<String> genres;
  final String collection;

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return false;

    return title.toLowerCase().contains(normalized) ||
        collection.toLowerCase().contains(normalized) ||
        genres.any((genre) => genre.toLowerCase().contains(normalized));
  }

  /// Builds the existing details model from a search result.
  ///
  /// The current details screen expects the full model. The artwork and the
  /// headline data come from this result; the remaining editorial fields use
  /// the sample content already present in the app.
  MovieDetailsModel toDetails() {
    return MovieDetailsModel(
      title: title,
      year: year,
      posterAsset: posterAsset,
      likes: 15,
      runtimeMinutes: 90,
      rating: rating,
      screenshots: MovieDetailsModel.sample.screenshots,
      similarMovies: MovieDetailsModel.sample.similarMovies,
      summary: MovieDetailsModel.sample.summary,
      cast: MovieDetailsModel.sample.cast,
      genres: genres,
    );
  }
}

/// Local search catalog used until the movie data layer is available.
const List<SearchMovie> searchCatalog = [
  SearchMovie(
    title: 'Black Widow',
    year: 2021,
    posterAsset: AppAssets.movieDetailsSimilarBlackWidow,
    rating: 7.7,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    collection: 'Marvel',
  ),
  SearchMovie(
    title: 'Captain America: The First Avenger',
    year: 2011,
    posterAsset: AppAssets.movieDetailsSimilarCaptainAmerica,
    rating: 7.7,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    collection: 'Marvel',
  ),
  SearchMovie(
    title: 'Iron Man 3',
    year: 2013,
    posterAsset: AppAssets.searchIronMan3,
    rating: 7.7,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    collection: 'Marvel',
  ),
  SearchMovie(
    title: 'Captain America: Civil War',
    year: 2016,
    posterAsset: AppAssets.movieDetailsSimilarCivilWar,
    rating: 7.7,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    collection: 'Marvel',
  ),
  SearchMovie(
    title: 'Doctor Strange in the Multiverse of Madness',
    year: 2022,
    posterAsset: AppAssets.movieDetailsPoster,
    rating: 7.6,
    genres: ['Action', 'Sci-Fi', 'Adventure', 'Fantasy', 'Horror'],
    collection: 'Marvel',
  ),
  // The Figma result frame groups this poster with the five Marvel cards.
  // The local preview catalog mirrors that frame; a real data source will
  // replace these sample entries with the API's own collection data.
  SearchMovie(
    title: 'Joker',
    year: 2019,
    posterAsset: AppAssets.searchJoker,
    rating: 7.7,
    genres: ['Crime', 'Drama', 'Thriller'],
    collection: 'Marvel',
  ),
];
