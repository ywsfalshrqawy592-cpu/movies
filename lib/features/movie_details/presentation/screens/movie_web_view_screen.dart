import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movie_details/new_cubit/movie_web_view_model.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_web_view_app_bar.dart';
import 'package:movies_app/features/movies/data/models/movie_details.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoviesWebView extends StatelessWidget {
  const MoviesWebView({super.key, required this.movieDetails});

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    final url = movieDetails.url;
    if (url == null || url.isEmpty) {
      return Scaffold(
        body: Center(
          child: Icon(Icons.error_outline, color: AppColors.grayColor),
        ),
      );
    }

    return BlocProvider(
      create: (_) => MovieWebViewModel(url),
      child: BlocBuilder<MovieWebViewModel, int>(
        builder: (context, progress) {
          final viewModel = context.read<MovieWebViewModel>();
          return Scaffold(
            appBar: MoviesWebViewAppBar(
              title: movieDetails.title ?? '',
              controller: viewModel.controller,
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: viewModel.controller),
                if (progress < 100)
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: AppColors.webProgressGradient,
                    ).createShader(bounds),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: AppColors.webProgressBackground,
                      color: AppColors.whiteColor,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
