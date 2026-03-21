import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Center content ─────────────────────────
              const Spacer(),

              // ── Checkmark ─────────────────────────────
              SizedBox(
                width: 120.w,
                height: 80.h,
                child: Icon(
                  Icons.check_rounded,
                  size: 80.sp,
                  color: const Color(0xFF4CAF50),
                ),
              ),
              SizedBox(height: 32.h),

              // ── Title ─────────────────────────────────
              Text(
                "You're all done!",
                style: AppTextStyles.body.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                  fontFamily: AppTextStyles.fontFamilyBeVietnam,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // ── Subtitle ──────────────────────────────
              Text(
                'Hang tight! We are currently reviewing your account and '
                'will follow up with you in 2–3 business days. In the '
                'meantime, you can setup your inventory.',
                style: AppTextStyles.body.copyWith(
                  fontSize: 13.sp,
                  color: const Color(0xFF898989),
                  height: 1.6,
                  fontFamily: AppTextStyles.fontFamilyBeVietnam,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // ── Got it button ─────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Got it!',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: AppTextStyles.fontFamilyBeVietnam,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
