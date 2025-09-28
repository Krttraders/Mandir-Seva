import 'package:flutter/material.dart';
import '../services/mock_service.dart';

class DisplayBoard extends StatelessWidget {
  const DisplayBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final slots = MockService.slots;
    final crowd = MockService.getCrowdDensity();

    return Scaffold(
      appBar: AppBar(title: const Text("Display Board")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Current Wait Time: ~15 mins",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (slots.isNotEmpty)
              Text(
                "Next Slot: ${slots.first.label}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            const SizedBox(height: 16),
            Text(
              "Crowd Status: $crowd",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
