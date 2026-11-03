

import 'package:flutter/material.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movies_web_view_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../api/model/movie_details/movie_details.dart';

class MoviesWebView extends StatefulWidget {
  const MoviesWebView({super.key, required this.movieDetails});

  final MovieDetails movieDetails;

  @override
  State<MoviesWebView> createState() => _MoviesWebViewState();
}

class _MoviesWebViewState extends State<MoviesWebView> {
  late WebViewController controller;

  int loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingProgress = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingProgress = 100;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.movieDetails.url!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoviesWebViewAppBar(
        title: widget.movieDetails.title ?? '',
        controller: controller,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingProgress < 100.1)
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF00D9FF), // Cyan
                    Color(0xFF009DFF), // Sky Blue
                    Color(0xFF2563EB), // Blue
                    Color(0xFF6366F1), // Indigo
                    Color(0xFF8B5CF6), // Purple
                    Color(0xFFB026FF), // Violet
                    Color(0xFFE040FB), // Pink
                    Color(0xFFFF4D8D), // Rose
                  ],
                ).createShader(bounds);
              },
              child: LinearProgressIndicator(
                value: loadingProgress / 100,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                color: Colors.white,
                minHeight: 5,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        ],
      ),
    );
  }
}
