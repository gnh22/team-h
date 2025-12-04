import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/critter_viewmodel.dart';
import 'glossary_page.dart';
import 'widgets/critter_tile.dart';
import 'widgets/info_tile.dart';

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
                    // Info tiles
                    InfoTile(
                      time: DateFormat.jm().format(DateTime(2025, 1, 1, vm.hour, vm.minute)),
                      month: DateFormat.MMMM().format(vm.current),
                      hemisphere: vm.hemisphere[0].toUpperCase() + vm.hemisphere.substring(1),
                    ),
                    // Critter list
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.critters.length,
                        itemBuilder: (_, i) =>
                            CritterTile(critter: vm.critters[i]),
                      ),
                    ),
                  ],
                ),
    );
  }
}
