import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../domain/models/onboarding_item.dart';
import '../../infra/controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCtaTap() async {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final state = ref.read(onboardingControllerProvider);
    if (state.isLastPage) {
      await controller.completeOnboarding();
      if (mounted) context.go(AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onLoginTap() => context.go(AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final currentItem = onboardingItems[state.currentPage];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // Matches current slide bg — zero color flash on swipe
        backgroundColor: currentItem.backgroundColor,
        body: PageView.builder(
          controller: _pageController,
          itemCount: onboardingItems.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (_, index) {
            final item = onboardingItems[index];
            return OnboardingPageCard(
              item: item,
              currentIndex: state.currentPage,
              totalCount: onboardingItems.length,
              onCtaTap: _onCtaTap,
              onLoginTap: _onLoginTap,
              isLoading: state.isLoading,
            );
          },
        ),
      ),
    );
  }
}