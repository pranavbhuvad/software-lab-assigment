class OnboardingState {
  final int currentPage;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.currentPage = 0,
    this.isLoading = false,
    this.error,
  });

  bool get isLastPage => currentPage == 2;

  OnboardingState copyWith({
    int? currentPage,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingState &&
          runtimeType == other.runtimeType &&
          currentPage == other.currentPage &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => Object.hash(currentPage, isLoading, error);
}
