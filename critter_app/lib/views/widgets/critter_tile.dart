import 'package:flutter/material.dart';
import '../../models/critter.dart';

class CritterTile extends StatelessWidget {
  final Critter critter;

  const CritterTile({super.key, required this.critter});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(critter.imageUrl, width: 50, height: 50),
        title: Text(critter.name),
      ),
    );
  }
}
