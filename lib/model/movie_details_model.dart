class CastMember {
  const CastMember({
    required this.name,
    required this.character,
    required this.imageUrl,
  });

  final String name;
  final String character;
  final String imageUrl;
}

class SimilarMovie {
  const SimilarMovie({required this.posterUrl, required this.rating});

  final String posterUrl;
  final double rating;
}

class MovieDetailsModel {
  const MovieDetailsModel({
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.likes,
    required this.runtime,
    required this.rating,
    required this.screenshots,
    required this.similar,
    required this.summary,
    required this.cast,
    required this.genres,
  });

  final String title;
  final int year;
  final String posterUrl;
  final int likes;
  final int runtime;
  final double rating;
  final List<String> screenshots;
  final List<SimilarMovie> similar;
  final String summary;
  final List<CastMember> cast;
  final List<String> genres;

  /// Mock data to preview the screen (empty urls show the placeholder).
  static const MovieDetailsModel sample = MovieDetailsModel(
    title: 'Doctor Strange in the Multiverse of Madness',
    year: 2022,
    posterUrl: '',
    likes: 15,
    runtime: 90,
    rating: 7.6,
    screenshots: ['', '', ''],
    similar: [
      SimilarMovie(posterUrl: '', rating: 7.6),
      SimilarMovie(posterUrl: '', rating: 7.6),
      SimilarMovie(posterUrl: '', rating: 7.1),
      SimilarMovie(posterUrl: '', rating: 7.9),
    ],
    summary:
    'Following the events of Spider-Man No Way Home, Doctor Strange '
        'unwittingly casts a forbidden spell that accidentally opens up '
        'the multiverse. With help from Wong and Scarlet Witch, Strange '
        'confronts various versions of himself as well as teaming up with '
        'the young heroine America Chavez while traveling through various '
        'realities and working to restore reality as he knows it.',
    cast: [
      CastMember(name: 'Hayley Atwell', character: 'Captain Carter', imageUrl: ''),
      CastMember(name: 'Elizabeth Olsen', character: 'Wanda Maximoff / The Scarlet Witch', imageUrl: ''),
      CastMember(name: 'Rachel McAdams', character: 'Dr. Christine Palmer', imageUrl: ''),
      CastMember(name: 'Charlize Theron', character: 'Clea', imageUrl: ''),
    ],
    genres: ['Action', 'Sci-Fi', 'Adventure', 'Fantasy', 'Horror'],
  );
}