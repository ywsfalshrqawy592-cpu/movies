import 'package:flutter/material.dart';

class MovieGradient extends StatelessWidget {
  const MovieGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, 0.0, 1.0],
            colors: [Color(0xFF000000), Color(0xCC000000), Color(0x99000000)],
          ),
        ),
      ),
    );
  }
}
