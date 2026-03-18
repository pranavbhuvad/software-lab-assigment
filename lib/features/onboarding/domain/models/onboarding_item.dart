import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingItem {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color ctaColor;
  final String illustrationAsset;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.ctaColor,
    required this.illustrationAsset,
  });
}

final List<OnboardingItem> onboardingItems = [
  const OnboardingItem(
    title: 'Quality',
    description:
        'Sell your farm fresh products directly to consumers, cutting out the middleman and reducing emissions of the global supply chain.',
    backgroundColor: AppColors.slideGreen,
    ctaColor: AppColors.ctaGreen,
    illustrationAsset: 'assets/illustrations/farm_quality.svg',
  ),
  const OnboardingItem(
    title: 'Convenient',
    description:
        'Our team of delivery drivers will make sure your orders are picked up on time and promptly delivered to your customers.',
    backgroundColor: AppColors.slideBrown,
    ctaColor: AppColors.ctaBrown,
    illustrationAsset: 'assets/illustrations/farm_local.svg',
  ),
  const OnboardingItem(
    title: 'Local',
    description:
        'We love the earth and know you do too! Join us in reducing our local carbon footprint one order at a time.',
    backgroundColor: AppColors.slideYellow,
    ctaColor: AppColors.ctaYellow,
    illustrationAsset: 'assets/illustrations/farm_convenient.svg',
  ),
];
