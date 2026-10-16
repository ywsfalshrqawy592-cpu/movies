import 'package:flutter/material.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/auth_footer_text.dart';
import '../../widgets/custom_elevated_botton.dart';
import '../../widgets/language_switch.dart';
import 'auth_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(AppAssets.splash, width: 121, height: 118),
              const SizedBox(height: 69),
              const AuthField(
                hint: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 22),
              const AuthField(
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 17),
              const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'Forget Password ?',
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 14),
                ),
              ),
              const SizedBox(height: 33),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: CustomElevatedBotton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.homeRouteName,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: AppColors.fieldColor, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 23),
              AuthFooterText(
                question: 'Don’t Have Account ?',
                action: 'Create One',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.registerRouteName),
              ),
              const SizedBox(height: 27),
              const OrDivider(),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: CustomElevatedBotton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.google, width: 26, height: 26),
                      const SizedBox(width: 10),
                      const Text(
                        'Login With Google',
                        style: TextStyle(
                          color: AppColors.fieldColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 33),
              const LanguageSwitch(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
