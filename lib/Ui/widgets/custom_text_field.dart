import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

typedef OnChange = void Function(String)?;
typedef OnValidator = String? Function(String?);

class CustomTextField extends StatelessWidget {
  final Color? borderColor;
  final Color? cursorColor;
  final String? hintText;

  final String? labelText;

  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;
  final OnChange? onChange;
  final OnValidator? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLines;
  final bool? filled;
  final Color? fillColor;
  final String? obscuringCharacter;

  const CustomTextField({
    super.key,
    this.borderColor,
    this.cursorColor,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.controller,
    this.onChange,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.maxLines,
    this.obscuringCharacter,
    this.filled,
    this.fillColor,
    KeybordTtype,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: cursorColor ?? AppColors.primaryColor,
      controller: controller,
      onChanged: onChange,
      validator: validator,
      style: style,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      maxLines: obscureText == true ? 1 : maxLines,
      obscuringCharacter: obscuringCharacter ?? '*',
      decoration: InputDecoration(
        enabledBorder: _buildOutlineInputBorder(
          borderColor: borderColor ?? Theme.of(context).highlightColor,
        ),
        focusedBorder: _buildOutlineInputBorder(
          borderColor: borderColor ?? Theme.of(context).highlightColor,
        ),
        errorBorder: _buildOutlineInputBorder(borderColor: AppColors.redColor),
        focusedErrorBorder: _buildOutlineInputBorder(
          borderColor: AppColors.redColor,
        ),
        hintText: hintText,
        labelText: labelText,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor:fillColor ,
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 2, color: borderColor),
    );
  }
}
