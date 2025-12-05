import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/critter_viewmodel.dart';
import 'widgets/critter_tile.dart';

class GlossaryPage extends StatefulWidget {
  const GlossaryPage({super.key});

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CritterViewModel>();

    // Filter critters based on search
    final filtered = vm.allCritters.where((c) {
      return c.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 112, 198, 154).withOpacity(0.5),
        title: const Text("Glossary"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search critters...",
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => query = value);
              },
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (_, i) => CritterTile(critter: filtered[i]),
        ),
      ),
    );
  }
}
