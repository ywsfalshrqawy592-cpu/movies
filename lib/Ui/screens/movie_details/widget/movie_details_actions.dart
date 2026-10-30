import 'package:flutter/material.dart';

class MovieDetailsActions extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onBookmarkTap;
  final VoidCallback onBackTap;

  const MovieDetailsActions({
    super.key,
    required this.isSelected,
    required this.onBookmarkTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: onBookmarkTap,
            icon: Icon(
              isSelected ? Icons.bookmark : Icons.bookmark_border,
              color: isSelected ? Colors.yellow : Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}