import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSource({required this.sharedPreferences});

  static const String _isTutorialShownKey = 'isTutorialShown';

  Future<void> markTutorialShown() async {
    await sharedPreferences.setBool(_isTutorialShownKey, true);
  }

  bool isTutorialShown() {
    return sharedPreferences.getBool(_isTutorialShownKey) ?? false;
  }
}
