import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth_field.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

import '../../../../cubit/update_profile/update_profile_cubit.dart';
import '../../../../cubit/update_profile/update_profile_state.dart';
import '../../../widgets/avatar_picker_sheet.dart';
import '../../../widgets/profile_avatar.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateProfileCubit(),
      child: const _UpdateProfileView(),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  const _UpdateProfileView();

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  final _nameController = TextEditingController(text: 'John Safwat');
  final _phoneController = TextEditingController(text: '01200000000');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _openAvatarPicker() {
    final cubit = context.read<UpdateProfileCubit>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparentColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AvatarPickerSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Pick Avatar',
          style: AppStyles.regular16Primary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                builder: (context, state) => ProfileAvatar(
                  avatar: state.selectedAvatar,
                  onTap: _openAvatarPicker,
                ),
              ),
              const SizedBox(height: 24),
              AuthField(
                controller: _nameController,
                hint: 'Name',
                icon: Icons.person,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              AuthField(
                controller: _phoneController,
                hint: 'Phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    // TODO: Navigator.pushNamed(context, AppRoutes.resetPassword);
                  },
                  child: Text(
                    'Reset Password',
                    style: AppStyles.regular14White,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedBotton(
                  backgroundColor: AppColors.redColor,
                  padding: 16,
                  onPressed: () {
                    // TODO: delete account
                  },
                  child: Text(
                    'Delete Account',
                    style: AppStyles.regular16White,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedBotton(
                  padding: 16,
                  onPressed: () {
                    // TODO: update profile
                  },
                  child: Text(
                    'Update Data',
                    style: AppStyles.regular16Black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
