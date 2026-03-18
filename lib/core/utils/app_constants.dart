abstract final class AppConstants {
  // API
  static const String baseUrl = 'https://api.yourfarmapp.com/v1';
  static const int connectTimeoutSec = 15;
  static const int receiveTimeoutSec = 15;

  // Pagination
  static const int defaultPageSize = 20;

  // Animation
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 600);

  // Onboarding
  static const int onboardingPageCount = 3;

  // Assets base paths
  static const String illustrationsPath = 'assets/illustrations/';
  static const String fontsPath = 'assets/fonts/';
  static const String iconsPath = 'assets/icons/';
}
