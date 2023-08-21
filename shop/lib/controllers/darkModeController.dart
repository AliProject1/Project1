import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeController extends GetxController {
  RxBool darkMode = false.obs;

  final _darkModeKey = 'darkMode'; // Key to store dark mode value in SharedPreferences

  @override
  void onInit() {
    super.onInit();
    // Load dark mode value from SharedPreferences when the controller is initialized
    loadDarkMode();
  }

  // Function to change dark mode value
  void changeDarkMode(bool status) {
    darkMode.value = status;
    // Save dark mode value to SharedPreferences
    saveDarkMode(status);
  }

  // Function to save dark mode value to SharedPreferences
  void saveDarkMode(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, status);
  }

  // Function to load dark mode value from SharedPreferences
  void loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDarkModeValue = prefs.getBool(_darkModeKey);
    if (storedDarkModeValue != null) {
      darkMode.value = storedDarkModeValue;
    }
  }
}
