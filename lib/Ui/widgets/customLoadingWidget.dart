import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  final bool isDark;

  const CustomLoadingWidget({
    super.key,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: isDark ? Colors.white : Colors.yellow,
      ),
    );
  }
}