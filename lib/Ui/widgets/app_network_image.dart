import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';

/// Network image with loading + error/empty placeholder and optional radius.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  Widget _placeholder() => Container(
    width: width,
    height: height,
    color: AppColors.fieldColor,
    alignment: Alignment.center,
    child: const Icon(Icons.movie_outlined, color: AppColors.grayColor),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: url.isEmpty
          ? _placeholder()
          : Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (_, child, progress) =>
        progress == null ? child : _placeholder(),
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }
}