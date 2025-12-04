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
    location: json['location'] ?? 'Unknown',
    sellNook: json['sell_nook'] is int
        ? json['sell_nook'] as int
        : int.tryParse(json['sell_nook'].toString()) ?? 0,
  );
}
}



// class Availability {
//   final String months;
//   final String? time;

//   Availability({required this.months, this.time});

//   factory Availability.fromJson(Map<String, dynamic> json) {
//     return Availability(
//       months: json['months'] ?? 'Unknown',
//       time: json['time'],
//     );
//   }
// }


// class Critter {
//   final String name;
//   final String imageUrl;
//   final List<int> monthsNorthern;
//   final List<int> monthsSouthern;
//   final bool allYear;
//   final String? time;
//   final String? location;
//   final int? sellNook;
//   final List<Availability> northAvailability;
//   final List<Availability> southAvailability;


//   Critter({
//     required this.name,
//     required this.imageUrl,
//     required this.monthsNorthern,
//     required this.monthsSouthern,
//     required this.allYear,
//     this.location,
//     this.sellNook,
//     this.time,
//     required this.northAvailability,
//     required this.southAvailability
//   });

//  factory Critter.fromJson(Map<String, dynamic> json) {
//   List<int> extractMonths(dynamic monthData) {
//     if (monthData == null) return [];
//     List<int> months = [];
//     for (var entry in (monthData as Map).entries) {
//       String monthNum = entry.key;
//       String availability = entry.value;
//       if (availability != "NA") {
//         months.add(int.parse(monthNum));
//       }
//     }
//     return months;
//   }

//    List<Availability> parseAvailability(dynamic data) {
//     if (data == null || data['availability_array'] == null) return [];
//     return (data['availability_array'] as List)
//         .map((item) => Availability.fromJson(item))
//         .toList();
//   }

//   final north = extractMonths(json["times_by_month_north"]);
//   final south = extractMonths(json["times_by_month_south"]);

//   return Critter(
//     name: json["name"] ?? "",
//     imageUrl: json["image_url"] ?? "",
//     monthsNorthern: north,
//     monthsSouthern: south,
//     allYear: north.length == 12 && south.length == 12,
//     time: json["time"],
//     location: json['location'] ?? 'Unknown',
//     sellNook: json['sell_nook'] is int
//         ? json['sell_nook'] as int
//         : int.tryParse(json['sell_nook'].toString()) ?? 0,
//     northAvailability: parseAvailability(json["north"]),
//     southAvailability: parseAvailability(json["south"]),
//   );
// }

// }

// class Critter {
//   final String name;
//   final String imageUrl;
//   final String northMonths;
//   final String southMonths;
//   final String? northTime;
//   final String? southTime;
//   final String? location;
//   final int? sellNook;

//   Critter({
//     required this.name,
//     required this.imageUrl,
//     required this.northMonths,
//     required this.southMonths,
//     this.northTime,
//     this.southTime,
//     this.location,
//     this.sellNook,
//   });

//   factory Critter.fromJson(Map<String, dynamic> json) {
//     return Critter(
//       name: json['name'] ?? '',
//       imageUrl: json['image_url'] ?? '',
//       northMonths: json['north']?['months'] ?? 'Unknown',
//       southMonths: json['south']?['months'] ?? 'Unknown',
//       northTime: json['north']?['times_by_month']?.values.firstWhere(
//         (v) => v != 'NA',
//         orElse: () => null,
//       ),
//       southTime: json['south']?['times_by_month']?.values.firstWhere(
//         (v) => v != 'NA',
//         orElse: () => null,
//       ),
//       location: json['location'] ?? 'Unknown',
//       sellNook: json['sell_nook'] is int
//           ? json['sell_nook'] as int
//           : int.tryParse(json['sell_nook'].toString()) ?? 0,
//     );
//   }
// }
