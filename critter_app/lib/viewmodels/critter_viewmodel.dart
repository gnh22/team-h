import 'package:flutter/foundation.dart';
import '../models/critter.dart';
import '../services/api_service.dart';
import '../storage/preferences_service.dart';

class CritterViewModel extends ChangeNotifier {
  final ApiService api;
  final PreferencesService prefs;

  CritterViewModel({ApiService? api, PreferencesService? prefs})
      : api = api ?? ApiService(token: null),
        prefs = prefs ?? PreferencesService() {
    _startClock();
  }
  DateTime current = DateTime.now();
  String hemisphere = 'northern';
  int hour = DateTime.now().hour;
  int minute = DateTime.now().minute;

  List<Critter> allCritters = [];
  List<Critter> critters = [];
  bool loading = false;
  String? error;

  // ------------------------
  // CLOCK FUNCTIONALITY
  // ------------------------
  void _startClock() {
    _updateTime();

    Future.doWhile(() async {
      final now = DateTime.now();
      final waitSeconds = 60 - now.second;
      await Future.delayed(Duration(seconds: waitSeconds));

      _updateTime();
      return true;
    });
  }

  void _updateTime() {
    current = DateTime.now();
    hour = current.hour;
    minute = current.minute;
    notifyListeners();
  }

  // ------------------------
  // INITIALIZATION
  // ------------------------
  Future<void> initNow() async {
    hemisphere = await prefs.loadHemisphere();
    _updateTime(); // sets current, hour, minute
    await fetchAll();
  }

  // ------------------------
  // FETCH CRITTERS
  // ------------------------
  Future<void> fetchAll() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final bugs = await api.fetchCritters("bugs");
      final fish = await api.fetchCritters("fish");

      allCritters = [...bugs, ...fish];
      applyFilters();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ------------------------
  // FILTER CRITTERS
  // ------------------------
  void applyFilters() {

    critters = allCritters.where((c) {
      final months = hemisphere == "northern"
          ? c.monthsNorthern
          : c.monthsSouthern;

      // print("${c.name}: months=$months, contains ${current.month}? ${months.contains(current.month)}");

      if (months.isNotEmpty && !months.contains(current.month)) {
        return false;
      }

      if (c.time != null && c.time!.isNotEmpty) {
        return _isAvailableAtHour(c.time!, hour);
      }

      return true;
    }).toList();

    // print("Filtered critters: ${critters.length}");
    notifyListeners();
  }

  bool _isAvailableAtHour(String timeRange, int currentHour) {
    if (timeRange.toLowerCase().contains("all day")) {
      return true;
    }
    

    // Parse time ranges like "8 AM – 5 PM" or "9 PM – 4 AM"
    final regex = RegExp(r'(\d+)\s*(AM|PM)\s*[–-]\s*(\d+)\s*(AM|PM)');
    final match = regex.firstMatch(timeRange);

    if (match == null) return true;

    int startHour = int.parse(match.group(1)!);
    String startPeriod = match.group(2)!;
    int endHour = int.parse(match.group(3)!);
    String endPeriod = match.group(4)!;

    // Convert to 24-hour format
    if (startPeriod == "PM" && startHour != 12) startHour += 12;
    if (startPeriod == "AM" && startHour == 12) startHour = 0;
    if (endPeriod == "PM" && endHour != 12) endHour += 12;
    if (endPeriod == "AM" && endHour == 12) endHour = 0;

    // Handle overnight ranges (e.g., 9 PM – 4 AM)
    if (startHour > endHour) {
      return currentHour >= startHour || currentHour < endHour;
    } else {
      return currentHour >= startHour && currentHour < endHour;
    }
  }

  // ------------------------
  // HELPER FOR EXTERNAL FILTERING
  // ------------------------
  bool applyTimeFilter(String timeRange, int hourToCheck) {
    return _isAvailableAtHour(timeRange, hourToCheck);
  }
}
