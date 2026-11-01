class MovieScreenshot {
  MovieScreenshot({
    this.mediumScreenshotImage,
    this.largeScreenshotImage,
  });

  MovieScreenshot.fromJson(dynamic json) {
    mediumScreenshotImage = json['medium_image'];
    largeScreenshotImage = json['large_image'];
  }

  String? mediumScreenshotImage;
  String? largeScreenshotImage;

  Map<String, dynamic> toJson() {
    return {
      'medium_image': mediumScreenshotImage,
      'large_image': largeScreenshotImage,
    };
  }
}