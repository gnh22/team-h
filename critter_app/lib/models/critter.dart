class Critter {
  final String name;
  final String imageUrl;
  final List<int> monthsNorthern;
  final List<int> monthsSouthern;
  final bool allYear;
  final String? time;

  Critter({
    required this.name,
    required this.imageUrl,
    required this.monthsNorthern,
    required this.monthsSouthern,
    required this.allYear,
    this.time,
  });

  factory Critter.fromJson(Map<String, dynamic> json) {
  List<int> extractMonths(dynamic monthData) {
    if (monthData == null) return [];
    
    // monthData is an object like {"1":"NA","2":"NA","3":"8 AM – 5 PM",...}
    List<int> months = [];
    
    for (var entry in (monthData as Map).entries) {
      String monthNum = entry.key;
      String availability = entry.value;
      
      // If availability is not "NA", the critter is available that month
      if (availability != "NA") {
        months.add(int.parse(monthNum));
      }
    }
    
    return months;
  }

  final north = extractMonths(json["times_by_month_north"]);
  final south = extractMonths(json["times_by_month_south"]);

  return Critter(
    name: json["name"] ?? "",
    imageUrl: json["image_url"] ?? "",
    monthsNorthern: north,
    monthsSouthern: south,
    allYear: north.length == 12 && south.length == 12,
    time: json["time"],
  );
}
}
