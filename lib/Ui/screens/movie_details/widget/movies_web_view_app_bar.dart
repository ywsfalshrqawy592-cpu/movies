import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoviesWebViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final WebViewController controller;

  const MoviesWebViewAppBar({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        IconButton(
          onPressed: () => controller.goBack(),
          icon: const Icon(Icons.arrow_back),
        ),
        IconButton(
          onPressed: () => controller.reload(),
          icon: const Icon(Icons.replay),
        ),
        IconButton(
          onPressed: () => controller.goForward(),
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
