import 'package:flutter/material.dart';
import 'package:movies_app/Ui/widgets/auth_field.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
        title: const Text(
          'Forget Password',
          style: TextStyle(color: AppColors.primaryColor, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                AppAssets.forgetPassword,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              AuthField(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedBotton(
                  padding: 16,
                  onPressed: () {
                    // TODO: verify email / reset password logic
                  },
                  child: const Text(
                    'Verify Email',
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