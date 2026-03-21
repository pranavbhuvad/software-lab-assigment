import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;

  const StepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          'Signup $currentStep of $totalSteps',
          style: AppTextStyles.caption.copyWith(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: AppTextStyles.heading.copyWith(
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}