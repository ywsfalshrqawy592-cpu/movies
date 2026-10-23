import 'package:flutter/material.dart';
import 'package:movies_app/models/avatar_model.dart';

class ProfileAvatar extends StatelessWidget {
  final AvatarModel avatar;
  final VoidCallback onTap;

  const ProfileAvatar({super.key, required this.avatar, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 70,
        backgroundColor: const Color(0xFF7FC8F8),
        backgroundImage: AssetImage(avatar.image),
      ),
    );
  }
}