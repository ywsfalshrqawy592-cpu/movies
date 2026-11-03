import 'package:flutter/material.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/size_utils.dart';
import '../../widgets/auth_footer_text.dart';
import '../../widgets/custom_elevated_botton.dart';
import '../../widgets/language_switch.dart';
import 'auth_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.037),
          child: Column(
            children: [
              SizedBox(height: height * 0.043),
              Image.asset(
                AppAssets.splash,
                width: width * 0.28,
                height: height * 0.127,
              ),
              SizedBox(height: height * 0.074),
              AuthField(
                hint: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: height * 0.024),
              AuthField(
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: height * 0.018),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'Forget Password ?',
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 14),
                ),
              ),
              SizedBox(height: height * 0.035),
              SizedBox(
                width: double.infinity,
                height: height * 0.06,
                child: CustomElevatedBotton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.homeRouteName,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: AppColors.fieldColor, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: height * 0.025),
              AuthFooterText(
                question: 'Don’t Have Account ?',
                action: 'Create One',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.registerRouteName),
              ),
              SizedBox(height: height * 0.029),
              OrDivider(),
              SizedBox(height: height * 0.03),
              SizedBox(
                width: double.infinity,
                height: height * 0.06,
                child: CustomElevatedBotton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.google,
                        width: width * 0.06,
                        height: width * 0.06,
                      ),
                      SizedBox(width: width * 0.023),
                      Text(
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
              SizedBox(height: height * 0.035),
              LanguageSwitch(),
              SizedBox(height: height * 0.034),
            ],
          ),
        ),
      ),
    );
  }
}
