import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:software_lab/core/theme/app_colors.dart';
import 'package:software_lab/core/theme/app_text_styles.dart';
import 'package:software_lab/features/auth/presentation/widgets/auth_card.dart';
import 'package:software_lab/features/auth/presentation/widgets/sign_nav.dart';
import 'package:software_lab/features/auth/presentation/widgets/step_header.dart';
import 'package:software_lab/features/auth/presentation/widgets/upload_widget.dart';

class Step3Verification extends StatelessWidget {
  final File? file;
  final VoidCallback onPickFile, onRemoveFile, onContinue, onBack;

  const Step3Verification({
    super.key,
    required this.file,
    required this.onPickFile,
    required this.onRemoveFile,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            currentStep: 3,
            totalSteps: 4,
            title: 'Verification',
          ),
          Text(
            'Attached proof of Department of Agriculture registrations '
            'i.e. Florida Fresh, USDA Approved, USDA Organic',
            style: AppTextStyles.caption.copyWith(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          UploadWidget(
            file: file,
            onTap: onPickFile,
            onRemove: onRemoveFile,
          ),

          // ── Spacer pushes nav to bottom ─────────────────
          const Spacer(),
          SizedBox(height: 24.h),

          // ── Full width nav row ──────────────────────────
          Row(
            children: [
              // Back arrow button
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 44.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 20.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 78.w),
              // Continue button — Expanded = full remaining width
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}