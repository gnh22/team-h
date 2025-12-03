import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                    Text("Hour:  ${vm.hour}"),
                    Text("Month: ${vm.month}"),
                    Text("Hemisphere: ${vm.hemisphere}"),
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
