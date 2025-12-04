import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/critter_viewmodel.dart';
import 'widgets/critter_tile.dart';
import 'package:intl/intl.dart';

class CustomFilterPage extends StatefulWidget {
  const CustomFilterPage({super.key});

  @override
  State<CustomFilterPage> createState() => _CustomFilterPageState();
}

class _CustomFilterPageState extends State<CustomFilterPage> {
  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;
  int selectedMonth = DateTime.now().month;
  String selectedHemisphere = "northern";

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CritterViewModel>();

    // Filter critters based on user selections
    List filteredCritters = vm.allCritters.where((c) {
      // Month filter
      final months = selectedHemisphere == "northern"
          ? c.monthsNorthern
          : c.monthsSouthern;
      if (months.isNotEmpty && !months.contains(selectedMonth)) return false;

      // Time filter
      if (c.time != null && c.time!.isNotEmpty) {
        return vm.applyTimeFilter(c.time!, selectedHour);
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Custom Filter")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Hemisphere dropdown
            Row(
              children: [
                const Text("Hemisphere: "),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: selectedHemisphere,
                  items: const [
                    DropdownMenuItem(value: "northern", child: Text("Northern")),
                    DropdownMenuItem(value: "southern", child: Text("Southern")),
                  ],
                  onChanged: (value) {
                    setState(() => selectedHemisphere = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Month dropdown
            Row(
              children: [
                const Text("Month: "),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (i) {
                    return DropdownMenuItem(
                      value: i + 1,
                      child: Text(DateFormat.MMMM().format(DateTime(0, i + 1))),
                    );
                  }),
                  onChanged: (value) {
                    setState(() => selectedMonth = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Time picker
            Row(
              children: [
                const Text("Hour: "),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: selectedHour,
                  items: List.generate(24, (i) {
                    return DropdownMenuItem(
                        value: i, child: Text(DateFormat.j().format(DateTime(0, 1, 1, i))));
                  }),
                  onChanged: (value) {
                    setState(() => selectedHour = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Expanded list of filtered critters
            Expanded(
              child: ListView.builder(
                itemCount: filteredCritters.length,
                itemBuilder: (_, i) => CritterTile(critter: filteredCritters[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
