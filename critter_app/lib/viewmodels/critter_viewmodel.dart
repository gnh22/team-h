import 'package:flutter/foundation.dart';
import '../models/critter.dart';
import '../services/api_service.dart';
import '../storage/preferences_service.dart';

class CritterViewModel extends ChangeNotifier {
  final ApiService api;
  final PreferencesService prefs = PreferencesService();

  CritterViewModel({String? apiKey}) : api = ApiService(token: apiKey);

  DateTime current = DateTime.now();
  String hemisphere = 'northern';
  int hour = DateTime.now().hour;
  int month = DateTime.now().month;

  List<Critter> allCritters = [];
  List<Critter> critters = [];
  bool loading = false;
  String? error;

  void initNow() async {
    hemisphere = await prefs.loadHemisphere();
    current = DateTime.now();
    hour = current.hour;
    month = current.month;
    await fetchAll();
  }

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

  void applyFilters() {
  print("Current month: $month");
  print("Hemisphere: $hemisphere");
  print("Total critters: ${allCritters.length}");
  
  critters = allCritters.where((c) {
    final months = hemisphere == "northern"
        ? c.monthsNorthern
        : c.monthsSouthern;
    

    print("${c.name}: months=$months, contains $month? ${months.contains(month)}");

    // Check month availability
    if (months.isNotEmpty && !months.contains(month)) {
      return false;
    }

    // Check time availability
    if (c.time != null && c.time!.isNotEmpty) {
      return _isAvailableAtHour(c.time!, hour);
    }

    return true;
  }).toList();
  
  print("Filtered critters: ${critters.length}");
  notifyListeners();
}

bool _isAvailableAtHour(String timeRange, int currentHour) {
  // Handle "All day" case
  if (timeRange.toLowerCase().contains("all day")) {
    return true;
  }

  // Parse time ranges like "8 AM – 5 PM" or "9 PM – 4 AM"
  final regex = RegExp(r'(\d+)\s*(AM|PM)\s*[–-]\s*(\d+)\s*(AM|PM)');
  final match = regex.firstMatch(timeRange);
  
  if (match == null) return true; // If can't parse, show it
  
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
}
