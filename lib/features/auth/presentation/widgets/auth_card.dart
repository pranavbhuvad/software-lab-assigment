import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Brand row ──────────────────────────────
                        Row(
                          children: [
                            SizedBox(width: 8.w),
                            Text(
                              'FarmerEats',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.black,
                                fontFamily: AppTextStyles.fontFamilyBeVietnam,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // ── White card — Expanded so Spacer works ──
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}