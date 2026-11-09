import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieWebViewModel extends Cubit<int> {
  MovieWebViewModel(String url) : super(0) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => emit(0),
          onProgress: emit,
          onPageFinished: (_) => emit(100),
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  late final WebViewController controller;
}
