import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';

class MovieSummary extends StatelessWidget {
  final String summary;

  const MovieSummary({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Summary",
          style: AppStyles.bold24White,
        ),
        const SizedBox(height: 12),
        Text(
          summary,
          style: AppStyles.regular16White,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}