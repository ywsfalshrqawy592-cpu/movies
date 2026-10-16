import 'package:flutter/material.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/custom_text_field.dart';
import 'package:movies_app/utils/app_colors.dart';

/// مسار صورة الشاشة. صدّرها من Figma (الفريم 430x430) باسم
/// forget_password.png وحطها في assets/images
const String kForgetPasswordImage = 'assets/images/forget_password.png';

/// bg و field مش موجودين في AppColors، فسيبتهم هنا.
/// لو حاتم ضافهم، استبدلهم بـ AppColors.
class _C {
  static const bg = Color(0xFF121312);
  static const field = Color(0xFF282A28);
  static const primary = AppColors.primaryColor;
  static const white = AppColors.whiteColor;
}

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
          'Forget Password',
          style: TextStyle(color: _C.primary, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Image.asset(
                kForgetPasswordImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
                hintStyle: const TextStyle(color: _C.white, fontSize: 14),
                prefixIcon: const Icon(Icons.email, color: _C.white),
                style: const TextStyle(color: _C.white, fontSize: 16),
                filled: true,
                fillColor: _C.field,
                borderColor: AppColors.transparentColor,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedBotton(
                  backgroundColor: _C.primary,
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