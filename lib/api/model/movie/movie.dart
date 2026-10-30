class Movie {
  final int id;
  final String title;
  final String mediumCoverImage;
  final num rating;

  Movie({
    required this.id,
    required this.title,
    required this.mediumCoverImage,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      mediumCoverImage: json['medium_cover_image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }
}