import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<String> loadHemisphere() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("hemisphere") ?? "northern";
  }

  Future<void> saveHemisphere(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("hemisphere", value);
  }
}
