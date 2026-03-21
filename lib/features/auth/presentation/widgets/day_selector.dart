import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:software_lab/features/auth/infra/controllers/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DaySelector extends StatelessWidget {
  final String selectedDay;
  final void Function(String day) onDayTap;

  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(WeekDays.keys.length, (i) {
        final key = WeekDays.keys[i];
        final label = WeekDays.labels[i];
        final isSelected = key == selectedDay;

        return GestureDetector(
          onTap: () => onDayTap(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.inputFill,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}