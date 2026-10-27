import '../../../utils/app_assets.dart';

/// A movie shown in the "Similar" section.
class SimilarMovie {
  const SimilarMovie({required this.posterAsset, required this.rating});

  final String posterAsset;
  final double rating;
}

/// A member of the movie cast.
class CastMember {
  const CastMember({
    required this.name,
    required this.character,
    required this.imageAsset,
  });

  final String name;
  final String character;
  final String imageAsset;
}

/// The data needed by [MovieDetailsScreen].
///
/// The current branch has no movie data source yet, so the screen is built
/// around this small model. [sample] contains the content of the Figma frame
/// and is only used to preview the design; a real data source can pass its own
/// instance to the screen later.
class MovieDetailsModel {
  const MovieDetailsModel({
    required this.title,
    required this.year,
    required this.posterAsset,
    required this.likes,
    required this.runtimeMinutes,
    required this.rating,
    required this.screenshots,
    required this.similarMovies,
    required this.summary,
    required this.cast,
    required this.genres,
  });

  final String title;
  final int year;
  final String posterAsset;
  final int likes;
  final int runtimeMinutes;
  final double rating;
  final List<String> screenshots;
  final List<SimilarMovie> similarMovies;
  final String summary;
  final List<CastMember> cast;
  final List<String> genres;

  /// Content of the "Movie Details" frame in the Figma file.
  static const MovieDetailsModel sample = MovieDetailsModel(
    title: 'Doctor Strange in the Multiverse of Madness',
    year: 2022,
    posterAsset: AppAssets.movieDetailsPoster,
    likes: 15,
    runtimeMinutes: 90,
    rating: 7.6,
    screenshots: [
      AppAssets.movieDetailsShotBus,
      AppAssets.movieDetailsShotMultiverse,
      AppAssets.movieDetailsShotOctopus,
    ],
    similarMovies: [
      SimilarMovie(
        posterAsset: AppAssets.movieDetailsSimilarBlackWidow,
        rating: 7.7,
      ),
      SimilarMovie(
        posterAsset: AppAssets.movieDetailsSimilarCaptainAmerica,
        rating: 7.7,
      ),
      SimilarMovie(
        posterAsset: AppAssets.movieDetailsSimilarAvengersEndgame,
        rating: 7.7,
      ),
      SimilarMovie(
        posterAsset: AppAssets.movieDetailsSimilarCivilWar,
        rating: 7.7,
      ),
    ],
    summary:
        'Following the events of Spider-Man No Way Home, Doctor Strange '
        'unwittingly casts a forbidden spell that accidentally opens up the '
        'multiverse. With help from Wong and Scarlet Witch, Strange confronts '
        'various versions of himself as well as teaming up with the young '
        'America Chavez while traveling through various realities and working '
        'to restore reality as he knows it. Along the way, Strange and his '
        'allies realize they must take on a powerful new adversary who seeks '
        'to take over the multiverse.\u2014Blazer346',
    cast: [
      CastMember(
        name: 'Hayley Atwell',
        character: 'Captain Carter',
        imageAsset: AppAssets.movieDetailsCastHayley,
      ),
      CastMember(
        name: 'Elizabeth Olsen',
        character: 'Wanda Maximoff / The Scarlet Witch',
        imageAsset: AppAssets.movieDetailsCastElizabeth,
      ),
      CastMember(
        name: 'Rachel McAdams',
        character: 'Dr. Christine Palmer',
        imageAsset: AppAssets.movieDetailsCastRachel,
      ),
      CastMember(
        name: 'Charlize Theron',
        character: 'Clea',
        imageAsset: AppAssets.movieDetailsCastCharlize,
      ),
    ],
    genres: ['Action', 'Sci-Fi', 'Adventure', 'Fantasy', 'Horror'],
  );
}
