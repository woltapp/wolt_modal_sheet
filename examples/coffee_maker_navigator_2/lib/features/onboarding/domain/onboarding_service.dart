import 'package:coffee_maker_navigator_2/features/onboarding/data/repository/onboarding_repository.dart';

class OnboardingService {
  final OnboardingRepository _tutorialRepository;

  OnboardingService({required this._tutorialRepository});

  bool isTutorialShown() {
    return _tutorialRepository.isTutorialShown();
  }

  Future<void> markTutorialShown() async {
    await _tutorialRepository.markTutorialShown();
  }
}
