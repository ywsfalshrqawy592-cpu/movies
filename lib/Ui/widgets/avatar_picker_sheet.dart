import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/models/avatar_model.dart';
import 'package:movies_app/utils/app_colors.dart';

import '../../cubit/update_profile/update_profile_cubit.dart';
import '../../cubit/update_profile/update_profile_state.dart';
import 'avatar_item.dart';

class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
        builder: (context, state) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AvatarModel.avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (_, index) {
              final avatar = AvatarModel.avatars[index];
              return AvatarItem(
                avatar: avatar,
                isSelected: avatar.id == state.selectedAvatar.id,
                onTap: () {
                  context.read<UpdateProfileCubit>().selectAvatar(avatar);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}