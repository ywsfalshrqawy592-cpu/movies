import 'Torrents.dart';
import 'movie_cast_codel.dart';

class MovieDetails {
  MovieDetails({
    this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.likeCount,
    this.descriptionIntro,
    this.descriptionFull,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.torrents,
    this.dateUploaded,
    this.dateUploadedUnix,
    this.screenshots,
    this.cast,
  });

  MovieDetails.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    imdbCode = json['imdb_code'];
    title = json['title'];
    titleEnglish = json['title_english'];
    titleLong = json['title_long'];
    slug = json['slug'];
    year = json['year'];
    rating = json['rating'];
    runtime = json['runtime'];
    genres = json['genres'] != null ? List<String>.from(json['genres']) : [];

    likeCount = json['like_count'];
    descriptionIntro = json['description_intro'];
    descriptionFull = json['description_full'];
    ytTrailerCode = json['yt_trailer_code'];
    language = json['language'];
    mpaRating = json['mpa_rating'];
    backgroundImage = json['background_image'];
    backgroundImageOriginal = json['background_image_original'];
    smallCoverImage = json['small_cover_image'];
    mediumCoverImage = json['medium_cover_image'];
    largeCoverImage = json['large_cover_image'];

    if (json['torrents'] != null) {
      torrents = [];
      json['torrents'].forEach((v) {
        torrents!.add(Torrents.fromJson(v));
      });
    }

    dateUploaded = json['date_uploaded'];
    dateUploadedUnix = json['date_uploaded_unix'];

    screenshots = [
      if (json['large_screenshot_image1'] != null)
        json['large_screenshot_image1'],
      if (json['large_screenshot_image2'] != null)
        json['large_screenshot_image2'],
      if (json['large_screenshot_image3'] != null)
        json['large_screenshot_image3'],
    ];

    if (json['cast'] != null) {
      cast = [];
      json['cast'].forEach((v) {
        cast!.add(MovieCast.fromJson(v));
      });
    }
  }

  int? id;
  String? url;
  String? imdbCode;
  String? title;
  String? titleEnglish;
  String? titleLong;
  String? slug;
  int? year;
  double? rating;
  int? runtime;
  List<String>? genres;
  int? likeCount;
  String? descriptionIntro;
  String? descriptionFull;
  String? ytTrailerCode;
  String? language;
  String? mpaRating;
  String? backgroundImage;
  String? backgroundImageOriginal;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;
  List<Torrents>? torrents;
  String? dateUploaded;
  int? dateUploadedUnix;

  // Screenshots
  List<String>? screenshots;

  // Cast
  List<MovieCast>? cast;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = id;
    map['url'] = url;
    map['imdb_code'] = imdbCode;
    map['title'] = title;
    map['title_english'] = titleEnglish;
    map['title_long'] = titleLong;
    map['slug'] = slug;
    map['year'] = year;
    map['rating'] = rating;
    map['runtime'] = runtime;
    map['genres'] = genres;
    map['like_count'] = likeCount;
    map['description_intro'] = descriptionIntro;
    map['description_full'] = descriptionFull;
    map['yt_trailer_code'] = ytTrailerCode;
    map['language'] = language;
    map['mpa_rating'] = mpaRating;
    map['background_image'] = backgroundImage;
    map['background_image_original'] = backgroundImageOriginal;
    map['small_cover_image'] = smallCoverImage;
    map['medium_cover_image'] = mediumCoverImage;
    map['large_cover_image'] = largeCoverImage;

    if (torrents != null) {
      map['torrents'] = torrents!.map((v) => v.toJson()).toList();
    }

    map['date_uploaded'] = dateUploaded;
    map['date_uploaded_unix'] = dateUploadedUnix;

    for (int i = 0; i < (screenshots?.length ?? 0); i++) {
      map['large_screenshot_image${i + 1}'] = screenshots![i];
    }

    // if (cast != null) {
    //   map['cast'] = cast!.map((v) => v.toJson()).toList();
    // }

    return map;
  }
}
