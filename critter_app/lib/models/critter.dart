class Critter {
  final String name;
  final String imageUrl;
  final List<int> monthsNorthern;
  final List<int> monthsSouthern;
  final bool allYear;
  final String? time;
  final String? location;
  final int? sellNook;

  Critter({
    required this.name,
    required this.imageUrl,
    required this.monthsNorthern,
    required this.monthsSouthern,
    required this.allYear,
    this.time,
    this.location,
    this.sellNook,
  });

  factory Critter.fromJson(Map<String, dynamic> json) {
    List<int> extractMonths(dynamic monthData) {
      if (monthData == null) return [];
      
      // monthData is an object like {"1":"NA","2":"NA","3":"8 AM – 5 PM",...}
      List<int> months = [];
      
      for (var entry in (monthData as Map).entries) {
        String monthNum = entry.key;
        String availability = entry.value;
        
        // If availability is not "NA" (case-insensitive), the critter is available that month
        if (availability.toString().toUpperCase() != "NA") {
          months.add(int.parse(monthNum));
        }
      }
      
      return months;
    }

    final north = extractMonths(json["times_by_month_north"]);
    final south = extractMonths(json["times_by_month_south"]);

    return Critter(
      name: _normalizeString(json["name"]) ?? "",
      imageUrl: json["image_url"] ?? "",
      monthsNorthern: north,
      monthsSouthern: south,
      allYear: north.length == 12 && south.length == 12,
      time: _normalizeTime(json["time"]),
      location: _normalizeString(json['location']) ?? 'Unknown',
      sellNook: json['sell_nook'] is int
          ? json['sell_nook'] as int
          : int.tryParse(json['sell_nook'].toString()) ?? 0,
    );
  }

  // Helper method to normalize string casing (capitalize each word)
  static String? _normalizeString(dynamic value) {
    if (value == null) return null;
    String str = value.toString().trim();
    if (str.isEmpty) return null;
    
    // Capitalize first letter of each word
    return str.split(' ')
        .map((word) => word.isEmpty 
            ? '' 
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Helper method to normalize time strings
  static String? _normalizeTime(dynamic value) {
    if (value == null) return null;
    String str = value.toString().trim();
    if (str.isEmpty) return null;
    
    // Normalize "all day" variations (case-insensitive)
    final lowerStr = str.toLowerCase();
    if (lowerStr == 'all day' || lowerStr == 'allday' || lowerStr == 'all-day') {
      return 'All day';
    }
    
    // For time ranges, ensure proper formatting
    // This handles variations like "8 am - 5 pm" or "8AM-5PM"
    return str;
  }
}