import 'package:coffee_maker_navigator_2/data/onboarding/repository/onboarding_repository.dart';

class OnboardingService {
  final OnboardingRepository _tutorialRepository;

  OnboardingService({required OnboardingRepository tutorialRepository})
      : _tutorialRepository = tutorialRepository;

  bool isTutorialShown() {
    return _tutorialRepository.isTutorialShown();
  }

  Future<void> markTutorialShown() async {
    await _tutorialRepository.markTutorialShown();
  }
}
