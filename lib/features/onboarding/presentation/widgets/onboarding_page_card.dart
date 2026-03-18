import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/onboarding_item.dart';
import 'dot_indicator.dart';
import 'onboarding_cta_button.dart';

class OnboardingPageCard extends StatelessWidget {
  final OnboardingItem item;
  final int currentIndex;
  final int totalCount;
  final VoidCallback onCtaTap;
  final VoidCallback onLoginTap;
  final bool isLoading;

  const OnboardingPageCard({
    super.key,
    required this.item,
    required this.currentIndex,
    required this.totalCount,
    required this.onCtaTap,
    required this.onLoginTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Full screen white base — covers scaffold bg completely ──
        const ColoredBox(color: AppColors.white),

        // ── Illustration fills top portion ──────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenH * 0.52,
          child: _IllustrationPanel(item: item),
        ),

        // ── White rounded sheet overlapping illustration ─────────────
        Positioned(
          // Overlap illustration by 28px for the curved join
          top: screenH * 0.52 - 28.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  item.description,
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 47.h),
                DotIndicator(
                  count: totalCount,
                  activeIndex: currentIndex,
                ),
                SizedBox(height: 60.h),
                OnboardingCtaButton(
                  color: item.ctaColor,
                  onTap: onCtaTap,
                  isLoading: isLoading,
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: onLoginTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text('Login', style: AppTextStyles.login),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IllustrationPanel extends StatelessWidget {
  final OnboardingItem item;

  const _IllustrationPanel({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: item.backgroundColor,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SvgPicture.asset(
          item.illustrationAsset,
          width: 489.52,
          height: 372,
          fit: BoxFit.fill,
          placeholderBuilder: (_) => SizedBox(
            width: 489.52,
            height: 372,
            child: ColoredBox(color: item.backgroundColor),
          ),
        ),
      ),
    );
  }
}