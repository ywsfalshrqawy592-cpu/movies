import 'package:flutter/material.dart';

import '../../utils/size_utils.dart';


class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final bool isDark;

  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: context.width * 0.12,
            color: isDark ?  Colors.black54:Colors.white70,
          ),

          SizedBox(height: context.height * 0.015),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
            ),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.width * 0.04,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.black:Colors.white  ,
              ),
            ),
          ),

          SizedBox(height: context.height * 0.015),

          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Try Again',
              style: TextStyle(
                fontSize: context.width * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.05,
                vertical: context.height * 0.012,
              ),
            ),
          ),
        ],
      ),
    );
  }
}