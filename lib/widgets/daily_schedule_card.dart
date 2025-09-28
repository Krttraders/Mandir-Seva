import 'package:flutter/material.dart';

class DailyScheduleCard extends StatelessWidget {
  const DailyScheduleCard({super.key});

  // Mock data for the schedule
  static const List<Map<String, String>> mockSchedule = [
    {'time': '05:00 AM', 'event': 'Mangala Aarti (Morning Prayer)'},
    {'time': '07:30 AM', 'event': 'Shringar Darshan'},
    {'time': '12:00 PM', 'event': 'Rajbhog Aarti'},
    {'time': '04:00 PM', 'event': 'Uthhapan Darshan'},
    {'time': '07:30 PM', 'event': 'Sandhya Aarti (Evening Prayer)'},
    {'time': '09:00 PM', 'event': 'Shayan Aarti (Closing)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Darshan & Aarti Schedule 🔔',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange, // Theme color for the title
              ),
            ),
            const Divider(height: 20, thickness: 1),
            // Build the list of timings
            ...mockSchedule.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item['time']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['event']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}