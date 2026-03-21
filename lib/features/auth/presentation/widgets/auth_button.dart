import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? color;

  const AuthButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: bg.withOpacity(0.55),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            // Pill shape — matches Figma exactly
            borderRadius: BorderRadius.circular(117.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.h,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                  strokeCap: StrokeCap.round,
                ),
              )
            : Text(
                label,
                style: AppTextStyles.button.copyWith(fontSize: 15.sp),
              ),
      ),
    );
  }
}