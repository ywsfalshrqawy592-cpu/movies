import 'Torrents.dart';

/// id : 1
/// url : "https://yts.gg/movies/bikini-model-academy-2015"
/// imdb_code : "tt3208802"
/// title : "Bikini Model Academy"
/// title_english : "Bikini Model Academy"
/// title_long : "Bikini Model Academy (2015)"
/// slug : "bikini-model-academy-2015"
/// year : 2015
/// rating : 2.3
/// runtime : 84
/// genres : ["Action","Comedy"]
/// like_count : 37
/// description_intro : "Two goons desperate for money decides to start a Bikini Model Academy."
/// description_full : "Two goons desperate for money decides to start a Bikini Model Academy."
/// yt_trailer_code : "pOZbOY8liOA"
/// language : "en"
/// mpa_rating : "16"
/// background_image : "https://yts.gg/assets/images/movies/bikini_model_academy_2015/background.jpg"
/// background_image_original : "https://yts.gg/assets/images/movies/bikini_model_academy_2015/background.jpg"
/// small_cover_image : "https://yts.gg/assets/images/movies/bikini_model_academy_2015/small-cover.jpg"
/// medium_cover_image : "https://yts.gg/assets/images/movies/bikini_model_academy_2015/medium-cover.jpg"
/// large_cover_image : "https://yts.gg/assets/images/movies/bikini_model_academy_2015/large-cover.jpg"
/// torrents : [{"url":"https://yts.gg/torrent/download/80F67E2D236A1A2854876F6A409C92D2D54C3849","hash":"80F67E2D236A1A2854876F6A409C92D2D54C3849","quality":"720p","type":"bluray","is_repack":"0","video_codec":"x264","bit_depth":"8","audio_channels":"2.0","seeds":3,"peers":0,"size":"701.10 MB","size_bytes":735156634,"date_uploaded":"2015-10-31 16:40:51","date_uploaded_unix":1446306051},{"url":"https://yts.gg/torrent/download/BA2DD0FB35E9055372873D420E5C951CD41D6A8F","hash":"BA2DD0FB35E9055372873D420E5C951CD41D6A8F","quality":"1080p","type":"bluray","is_repack":"0","video_codec":"x264","bit_depth":"8","audio_channels":"2.0","seeds":4,"peers":2,"size":"1.24 GB","size_bytes":1331439862,"date_uploaded":"2015-10-31 16:40:56","date_uploaded_unix":1446306056}]
/// date_uploaded : "2015-10-31 16:40:51"
/// date_uploaded_unix : 1446306051

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
      this.dateUploadedUnix,});

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
    genres = json['genres'] != null ? json['genres'].cast<String>() : [];
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
        torrents?.add(Torrents.fromJson(v));
      });
    }
    dateUploaded = json['date_uploaded'];
    dateUploadedUnix = json['date_uploaded_unix'];
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
      map['torrents'] = torrents?.map((v) => v.toJson()).toList();
    }
    map['date_uploaded'] = dateUploaded;
    map['date_uploaded_unix'] = dateUploadedUnix;
    return map;
  }

}