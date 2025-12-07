import 'package:flutter/material.dart';
import '../../models/critter.dart';

class CritterTile extends StatefulWidget {
  final Critter critter;

  const CritterTile({super.key, required this.critter});

  @override
  State<CritterTile> createState() => _CritterTileState();
}

class _CritterTileState extends State<CritterTile> {
  bool expanded = false;

  String _formatMonths(List<int> months) {
    if (months.isEmpty) return "None";
    if (months.length == 12) return "All year";
    return months.map((m) => _monthName(m)).join(", ");
  }

  String _monthName(int m) {
    const names = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final critter = widget.critter;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => setState(() => expanded = !expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Always visible row ---
              Row(
                children: [
                  Image.network(critter.imageUrl, width: 50, height: 50),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      critter.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  )
                ],
              ),

              // --- Expandable details ---
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Northern: ${_formatMonths(critter.monthsNorthern)}"),
                      const SizedBox(height: 4),
                      Text("Southern: ${_formatMonths(critter.monthsSouthern)}"),

                      if (critter.time != null) ...[
                        const SizedBox(height: 4),
                        Text("Time: ${critter.time}"),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        "Location: ${critter.location}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text("Sell Price: ${critter.sellNook} bells"),
                      const SizedBox(height: 8),
                      Text(
                        critter.allYear
                            ? "Available all year"
                            : "Seasonal availability",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: critter.allYear
                              ? Colors.green[700]
                              : Colors.brown[700],
                        ),
                      ),
                    ],
                    
                  ),
                ),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
