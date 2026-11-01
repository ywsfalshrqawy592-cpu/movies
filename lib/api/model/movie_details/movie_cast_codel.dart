class MovieCast {
  final String? name;
  final String? characterName;
  final String? urlSmallImage;
  final String? imdbCode;

  MovieCast({
    this.name,
    this.characterName,
    this.urlSmallImage,
    this.imdbCode,
  });

  factory MovieCast.fromJson(Map<String, dynamic> json) {
    return MovieCast(
      name: json['name']?.toString(),
      characterName: json['character_name']?.toString(),
      urlSmallImage: json['url_small_image']?.toString(),
      imdbCode: json['imdb_code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character_name': characterName,
      'url_small_image': urlSmallImage,
      'imdb_code': imdbCode,
    };
  }
}