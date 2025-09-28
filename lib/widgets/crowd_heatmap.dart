import 'package:flutter/material.dart';

class CrowdHeatmap extends StatelessWidget {
  final String zoneDensity; // "Low" / "Medium" / "High"

  const CrowdHeatmap({super.key, required this.zoneDensity});

  @override
  Widget build(BuildContext context) {
    Color color;

    if (zoneDensity == "High") {
      color = Colors.red;
    } else if (zoneDensity == "Medium") {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Live Crowd Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            zoneDensity,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
