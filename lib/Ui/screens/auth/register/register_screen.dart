import 'package:flutter/material.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_styles.dart';
import '../../../../utils/size_utils.dart';
import '../../../widgets/auth_footer_text.dart';
import '../../../widgets/custom_elevated_botton.dart';
import '../../../widgets/language_switch.dart';
import '../../../widgets/auth_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Register',
          style: AppStyles.regular16Primary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.037),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppAssets.avatar_3,
                  width: width * 0.22,
                  height: width * 0.22,
                ),
                Image.asset(
                  AppAssets.avatar_1,
                  width: width * 0.37,
                  height: width * 0.37,
                ),
                Image.asset(
                  AppAssets.avatar_2,
                  width: width * 0.22,
                  height: width * 0.22,
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Avatar',
              style: AppStyles.regular16White,
            ),
            SizedBox(height: height * 0.013),
            AuthField(hint: 'Name', icon: Icons.badge_outlined),
            SizedBox(height: height * 0.026),
            AuthField(
              hint: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: height * 0.026),
            AuthField(hint: 'Password', icon: Icons.lock, isPassword: true),
            SizedBox(height: height * 0.026),
            AuthField(
              hint: 'Confirm Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            SizedBox(height: height * 0.026),
            AuthField(
              hint: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: height * 0.026),
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: CustomElevatedBotton(
                onPressed: () {},
                child: Text(
                  'Create Account',
                  style: AppStyles.regular20Background,
                ),
              ),
            ),
            SizedBox(height: height * 0.019),
            AuthFooterText(
              question: 'Already Have Account ?',
              action: 'Login',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: height * 0.019),
            LanguageSwitch(),
            SizedBox(height: height * 0.034),
          ],
        ),
      ),
    );
  }
}
