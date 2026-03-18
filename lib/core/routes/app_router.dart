import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';

abstract final class AppRoutes {
  static const String onboarding     = '/onboarding';
  static const String login          = '/login';
  static const String register       = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp      = '/verify-otp';
  static const String resetPassword  = '/reset-password';
  static const String home           = '/home';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (c, s) => _fade(s, const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (c, s) => _fade(s, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (c, s) => _fade(s, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        pageBuilder: (c, s) => _fade(s, const VerifyOtpScreen()),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        pageBuilder: (c, s) => _fade(s, const ResetPasswordScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (c, s) => _fade(
          s,
          const Scaffold(body: Center(child: Text('Home Screen'))),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (c, s) => _fade(
          s,
          const Scaffold(body: Center(child: Text('Register Screen'))),
        ),
      ),
    ],
  );
});

CustomTransitionPage _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}