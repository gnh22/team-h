import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/critter_viewmodel.dart';
import 'widgets/critter_tile.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CritterViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Glossary")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: vm.allCritters.length,
          itemBuilder: (_, i) => CritterTile(critter: vm.allCritters[i]),
        ),
      ),
    );
  }
}
