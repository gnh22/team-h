import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/critter_viewmodel.dart';
import 'glossary_page.dart';
import 'widgets/critter_tile.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CritterViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Critters Now"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GlossaryPage()),
              );
            },
          )
        ],
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text(vm.error!))
              : Column(
                children: [
                  Text(
                    "Time: ${DateFormat.jm().format(DateTime(2025, 1, 1, vm.hour, vm.minute))}",
                    style: const TextStyle(fontSize: 20),
                  ),

                  Text(
                    "Month: ${DateFormat.MMMM().format(vm.current)}",
                    style: const TextStyle(fontSize: 18),
                  ),

                  Text(
                    "Hemisphere: ${vm.hemisphere}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.critters.length,
                      itemBuilder: (_, i) => CritterTile(critter: vm.critters[i]),
                    ),
                  ),
                ],
              )

    );
  }
}
