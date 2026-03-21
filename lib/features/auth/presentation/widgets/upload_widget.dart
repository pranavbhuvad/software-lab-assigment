import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class UploadWidget extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const UploadWidget({
    super.key,
    this.file,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Attach proof of registration', style: AppTextStyles.body),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
        if (file != null) ...[
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file_outlined,
                    size: 16.sp, color: AppColors.textSecondary),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    file!.path.split('/').last,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onRemove ?? onTap,
                  child: Icon(Icons.close,
                      size: 16.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}