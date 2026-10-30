import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final String imageUrl;

  const MoviePoster({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 430,
        height: 645,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.white,
        ),
      ),
    );
  }
}