import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:software_lab/core/theme/app_colors.dart';

class SignupBackButton extends StatelessWidget {
  final VoidCallback onBack;

  const SignupBackButton({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        width: 26.w,
        height: 18.w,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.arrow_back,
            size: 20.sp, color: AppColors.textPrimary),
      ),
    );
  }
}