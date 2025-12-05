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
      final months = selectedHemisphere == "northern"
          ? c.monthsNorthern
          : c.monthsSouthern;
      if (months.isNotEmpty && !months.contains(selectedMonth)) return false;

      if (c.time != null && c.time!.isNotEmpty) {
        return vm.applyTimeFilter(c.time!, selectedHour);
      }

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Filter"),
        backgroundColor: const Color.fromARGB(255, 112, 198, 154).withOpacity(0.5), 
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Hemisphere
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Hemisphere"),
                          DropdownButton<String>(
                            value: selectedHemisphere,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: "northern",
                                child: Text("Northern"),
                              ),
                              DropdownMenuItem(
                                value: "southern",
                                child: Text("Southern"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => selectedHemisphere = value!);
                            },
                          ),
                        ],
                      ),

                      const Divider(),

                      // Month
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Month"),
                          DropdownButton<int>(
                            value: selectedMonth,
                            underline: const SizedBox(),
                            items: List.generate(12, (i) {
                              return DropdownMenuItem(
                                value: i + 1,
                                child: Text(
                                  DateFormat.MMMM().format(DateTime(0, i + 1)),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() => selectedMonth = value!);
                            },
                          ),
                        ],
                      ),

                      const Divider(),

                      // Hour
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Hour"),
                          DropdownButton<int>(
                            value: selectedHour,
                            underline: const SizedBox(),
                            items: List.generate(24, (i) {
                              return DropdownMenuItem(
                                value: i,
                                child: Text(
                                  DateFormat.j().format(DateTime(0, 1, 1, i)),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() => selectedHour = value!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredCritters.length,
                  itemBuilder: (_, i) => CritterTile(critter: filteredCritters[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
