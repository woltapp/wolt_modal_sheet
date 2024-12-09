import 'dart:async';

import 'package:coffee_maker_navigator_2/features/onboarding/data/local/onboarding_local_data_source.dart';

class OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepository({required this.localDataSource});

  bool isTutorialShown() {
    return localDataSource.isTutorialShown();
  }

  Future<void> markTutorialShown() async {
    await localDataSource.markTutorialShown();
  }
}
