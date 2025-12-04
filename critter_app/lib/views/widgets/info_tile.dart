import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String time;
  final String month;
  final String hemisphere;

  const InfoTile({
    super.key,
    required this.time,
    required this.month,
    required this.hemisphere,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Time", time),
            const SizedBox(height: 4),
            _buildRow("Month", month),
            const SizedBox(height: 4),
            _buildRow("Hemisphere", hemisphere),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18, // increase label font size
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18, // increase value font size
          ),
        ),
      ],
    );
  }
}
