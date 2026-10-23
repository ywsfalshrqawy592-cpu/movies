import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_messages.dart';
import 'package:movies_app/Ui/widgets/auth/auth_validators.dart';
import 'package:movies_app/Ui/widgets/auth/avatar_selector.dart';
import 'package:movies_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:movies_app/cubit/auth_cubit/update_profile_cubit.dart';
import 'package:movies_app/Ui/widgets/auth/auth_form_message.dart';
import 'package:movies_app/Ui/widgets/auth/delete_account_dialog.dart';
import 'package:movies_app/Ui/widgets/language_switch.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/custom_text_field.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_prefs.dart';
import 'package:movies_app/utils/app_routes.dart';

class _C {
  static const bg = AppColors.darkBackgroundColor;
  static const field = AppColors.darkFieldColor;
  static const primary = AppColors.primaryColor;
  static const danger = AppColors.redColor;
  static const white = AppColors.whiteColor;
}

const List<String> kAvatars = authAvatarAssets;

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (context) =>
          UpdateProfileCubit(context.read<AuthCubit>().service),
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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late int _selectedAvatar;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: AppPrefs.profilePhone);
    final avatarIndex = kAvatars.indexOf(user?.photoUrl ?? '');
    _selectedAvatar = avatarIndex < 0 ? 0 : avatarIndex;
  }

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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await context.read<UpdateProfileCubit>().update(
      name: _nameController.text,
      phone: _phoneController.text,
      avatarPath: kAvatars[_selectedAvatar],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        title: Text(
          l10n.authEditProfile,
          style: const TextStyle(color: _C.primary, fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 12),
            child: LanguageSwitch(),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.isSuccess) {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.of(context).pop();
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.authProfileUpdated)),
              );
            }
          },
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _openAvatarPicker,
                    child: Text(
                      l10n.authPickAvatar,
                      style: const TextStyle(color: _C.primary, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    hintText: l10n.authNameLabel,
                    hintStyle: const TextStyle(color: _C.white, fontSize: 14),
                    prefixIcon: const Icon(Icons.person, color: _C.white),
                    style: const TextStyle(color: _C.white, fontSize: 16),
                    filled: true,
                    fillColor: _C.field,
                    borderColor: AppColors.transparentColor,
                    validator: (value) {
                      final error = AuthValidators.validateName(value);
                      return error == null
                          ? null
                          : AuthMessages.nameError(l10n, error);
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    hintText: l10n.authPhoneLabel,
                    hintStyle: const TextStyle(color: _C.white, fontSize: 14),
                    prefixIcon: const Icon(Icons.phone, color: _C.white),
                    style: const TextStyle(color: _C.white, fontSize: 16),
                    filled: true,
                    fillColor: _C.field,
                    borderColor: AppColors.transparentColor,
                    validator: (value) {
                      final error = AuthValidators.validatePhone(value);
                      return error == null
                          ? null
                          : AuthMessages.phoneError(l10n, error);
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.forgotPasswordRouteName),
                      child: Text(
                        l10n.authResetPassword,
                        style: const TextStyle(color: _C.white, fontSize: 14),
                      ),
                    ),
                  ),
                  if (state.hasFailed)
                    AuthFormMessage(
                      text: AuthMessages.failure(l10n, state.failure!),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedBotton(
                      backgroundColor: _C.danger,
                      padding: 16,
                      onPressed: () => DeleteAccountDialog.show(context),
                      child: Text(
                        l10n.authDeleteAccount,
                        style: const TextStyle(color: _C.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedBotton(
                      backgroundColor: _C.primary,
                      padding: 16,
                      isLoading: state.isSubmitting,
                      onPressed: _submit,
                      child: Text(
                        l10n.authUpdateData,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    ? _C.primary.withValues(alpha: 0.6)
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
