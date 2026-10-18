import 'package:flutter/material.dart';

import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/custom_text_field.dart';
import 'package:movies_app/features/auth/presentation/widgets/delete_account_dialog.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';

class _C {
  static const bg = Color(0xFF121312);
  static const field = Color(0xFF282A28);
  static const primary = AppColors.primaryColor;
  static const danger = AppColors.redColor;
  static const white = AppColors.whiteColor;
}

const List<String> kAvatars = [
  'assets/images/avatar1.png',
  'assets/images/avatar2.png',
  'assets/images/avatar3.png',
  'assets/images/avatar4.png',
  'assets/images/avatar5.png',
  'assets/images/avatar6.png',
  'assets/images/avatar7.png',
  'assets/images/avatar8.png',
  'assets/images/avatar9.png',
];

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController(text: 'John Safwat');
  final _phoneController = TextEditingController(text: '01200000000');
  int _selectedAvatar = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _openAvatarPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AvatarPickerSheet(
        selected: _selectedAvatar,
        onSelected: (index) {
          setState(() => _selectedAvatar = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.primary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Pick Avatar',
          style: TextStyle(color: _C.primary, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _openAvatarPicker,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: const Color(0xFF7FC8F8),
                  backgroundImage: AssetImage(kAvatars[_selectedAvatar]),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(Icons.person, color: _C.white),
                style: const TextStyle(color: _C.white, fontSize: 16),
                filled: true,
                fillColor: _C.field,
                borderColor: AppColors.transparentColor,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone, color: _C.white),
                style: const TextStyle(color: _C.white, fontSize: 16),
                filled: true,
                fillColor: _C.field,
                borderColor: AppColors.transparentColor,
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
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.forgotPasswordRouteName);
                  },
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(color: _C.white, fontSize: 14),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedBotton(
                  backgroundColor: _C.danger,
                  padding: 16,
                  onPressed: () => DeleteAccountDialog.show(context),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: _C.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedBotton(
                  backgroundColor: _C.primary,
                  padding: 16,
                  onPressed: () {
                    // TODO: update profile
                  },
                  child: const Text(
                    'Update Data',
                    style: TextStyle(color: AppColors.blackColor, fontSize: 16),
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

class _AvatarPickerSheet extends StatelessWidget {
  const _AvatarPickerSheet({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.field,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: kAvatars.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final isSelected = index == selected;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? _C.primary.withOpacity(0.6)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.primary),
              ),
              child: Image.asset(kAvatars[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
