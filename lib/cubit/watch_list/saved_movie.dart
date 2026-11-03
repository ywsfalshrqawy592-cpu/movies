class SavedMovie {
  SavedMovie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  final int id;
  final String title;
  final String posterUrl;
  final num rating;

  factory SavedMovie.fromJson(Map<String, dynamic> json) => SavedMovie(
    id: (json['id'] as num?)?.toInt() ?? 0,
    title: json['title'] as String? ?? '',
    posterUrl: json['posterUrl'] as String? ?? '',
    rating: json['rating'] as num? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterUrl': posterUrl,
    'rating': rating,
  };
}
