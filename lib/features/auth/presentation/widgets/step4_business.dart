import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:software_lab/core/theme/app_colors.dart';
import 'package:software_lab/core/theme/app_text_styles.dart';
import 'package:software_lab/features/auth/infra/controllers/auth_controller.dart';
import 'package:software_lab/features/auth/presentation/widgets/auth_card.dart';
import 'package:software_lab/features/auth/presentation/widgets/day_selector.dart';
import 'package:software_lab/features/auth/presentation/widgets/primary_button.dart';
import 'package:software_lab/features/auth/presentation/widgets/sign_up.dart';
import 'package:software_lab/features/auth/presentation/widgets/step_header.dart';
import 'package:software_lab/features/auth/presentation/widgets/time_slot.dart';

class Step4BusinessHours extends StatelessWidget {
  final SignupState state;
  final String selectedDay;
  final void Function(String) onDayTap;
  final void Function(String) onToggleSlot;
  final VoidCallback onSubmit, onBack;
  final bool isLoading;

  const Step4BusinessHours({
    super.key,
    required this.state,
    required this.selectedDay,
    required this.onDayTap,
    required this.onToggleSlot,
    required this.onSubmit,
    required this.onBack,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
              currentStep: 4, totalSteps: 4, title: 'Business Hours'),
          Text(
            'Choose the hours your farm is open for pickups.\n'
            'This will allow customers to order deliveries.',
            style: AppTextStyles.caption,
          ),
          SizedBox(height: 20.h),
          DaySelector(selectedDay: selectedDay, onDayTap: onDayTap),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: TimeSlots.all.map((slot) {
              final isSelected =
                  state.businessHours[selectedDay]?.contains(slot) ?? false;
              return TimeSlotChip(
                label: slot,
                isSelected: isSelected,
                onTap: () => onToggleSlot(slot),
              );
            }).toList(),
          ),
          Spacer(),
          SizedBox(height: 32.h),
          Row(
            children: [
              SignupBackButton(onBack: onBack),
              SizedBox(width: 78.w),
              Expanded(
                child: PrimaryButton(
                  label: 'Signup',
                  onTap: onSubmit,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}