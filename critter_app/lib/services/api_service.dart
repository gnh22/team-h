import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/critter.dart';

class ApiService {
  final String? token;

  ApiService({required this.token});

  final base = "https://api.nookipedia.com/nh";

  Future<List<Critter>> fetchCritters(String type) async {
    final url = Uri.parse("$base/$type?thumbImage=original");

    final res = await http.get(url, headers: {
      "X-API-KEY": token ?? "",
      "Accept-Version": "1.0.0",
    });

    if (res.statusCode != 200) {
      throw Exception("Failed to load $type: ${res.statusCode}");
    }

    // Print the raw response to see what we're actually getting
    print("Raw API response (first item):");
    final List decoded = json.decode(res.body);
    if (decoded.isNotEmpty) {
      print(json.encode(decoded.first));
    }

    return decoded.map((c) => Critter.fromJson(c)).toList();
  }
}
