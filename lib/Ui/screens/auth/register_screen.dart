import 'package:flutter/material.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/auth_footer_text.dart';
import '../../widgets/custom_elevated_botton.dart';
import '../../widgets/language_switch.dart';
import 'auth_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register',
          style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AppAssets.avatar_3, width: 94, height: 94),
                Image.asset(AppAssets.avatar_1, width: 158, height: 161),
                Image.asset(AppAssets.avatar_2, width: 94, height: 94),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Avatar',
              style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const AuthField(hint: 'Name', icon: Icons.badge_outlined),
            const SizedBox(height: 24),
            const AuthField(
              hint: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            const AuthField(hint: 'Password', icon: Icons.lock, isPassword: true),
            const SizedBox(height: 24),
            const AuthField(
              hint: 'Confirm Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            const AuthField(
              hint: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: CustomElevatedBotton(
                onPressed: () {},
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: AppColors.backgroundColor, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AuthFooterText(
              question: 'Already Have Account ?',
              action: 'Login',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 18),
            const LanguageSwitch(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
