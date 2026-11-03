import 'movie_details.dart';

/// movie : {"id":1,"url":"https://yts.gg/movies/bikini-model-academy-2015","imdb_code":"tt3208802","title":"Bikini Model Academy","title_english":"Bikini Model Academy","title_long":"Bikini Model Academy (2015)","slug":"bikini-model-academy-2015","year":2015,"rating":2.3,"runtime":84,"genres":["Action","Comedy"],"like_count":37,"description_intro":"Two goons desperate for money decides to start a Bikini Model Academy.","description_full":"Two goons desperate for money decides to start a Bikini Model Academy.","yt_trailer_code":"pOZbOY8liOA","language":"en","mpa_rating":"16","background_image":"https://yts.gg/assets/images/movies/bikini_model_academy_2015/background.jpg","background_image_original":"https://yts.gg/assets/images/movies/bikini_model_academy_2015/background.jpg","small_cover_image":"https://yts.gg/assets/images/movies/bikini_model_academy_2015/small-cover.jpg","medium_cover_image":"https://yts.gg/assets/images/movies/bikini_model_academy_2015/medium-cover.jpg","large_cover_image":"https://yts.gg/assets/images/movies/bikini_model_academy_2015/large-cover.jpg","torrents":[{"url":"https://yts.gg/torrent/download/80F67E2D236A1A2854876F6A409C92D2D54C3849","hash":"80F67E2D236A1A2854876F6A409C92D2D54C3849","quality":"720p","type":"bluray","is_repack":"0","video_codec":"x264","bit_depth":"8","audio_channels":"2.0","seeds":3,"peers":0,"size":"701.10 MB","size_bytes":735156634,"date_uploaded":"2015-10-31 16:40:51","date_uploaded_unix":1446306051},{"url":"https://yts.gg/torrent/download/BA2DD0FB35E9055372873D420E5C951CD41D6A8F","hash":"BA2DD0FB35E9055372873D420E5C951CD41D6A8F","quality":"1080p","type":"bluray","is_repack":"0","video_codec":"x264","bit_depth":"8","audio_channels":"2.0","seeds":4,"peers":2,"size":"1.24 GB","size_bytes":1331439862,"date_uploaded":"2015-10-31 16:40:56","date_uploaded_unix":1446306056}],"date_uploaded":"2015-10-31 16:40:51","date_uploaded_unix":1446306051}

class Data {
  Data({
      this.movie,});

  Data.fromJson(dynamic json) {
    movie = json['movie'] != null ? MovieDetails.fromJson(json['movie']) : null;
  }
  MovieDetails? movie;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (movie != null) {
      map['movie'] = movie?.toJson();
    }
    return map;
  }

}