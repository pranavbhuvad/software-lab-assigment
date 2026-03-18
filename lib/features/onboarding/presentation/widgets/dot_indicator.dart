import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';

class DotIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const DotIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) => _Dot(isActive: i == activeIndex)),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: isActive ? 20.w : 6.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.dotActive : AppColors.dotInactive,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
