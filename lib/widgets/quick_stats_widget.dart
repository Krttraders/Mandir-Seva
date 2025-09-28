import 'package:flutter/material.dart';

class QuickStatsWidget extends StatelessWidget {
  final Future<Map<String, dynamic>> templeStats;

  const QuickStatsWidget({super.key, required this.templeStats});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: templeStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatsLoading();
        }

        if (snapshot.hasError) {
          return _buildStatsError();
        }

        final stats = snapshot.data!;
        return _buildStatsGrid(stats);
      },
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatItem(
          'Visitors Today',
          stats['visitorsToday'].toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatItem(
          'Live Visitors',
          stats['liveVisitors'].toString(),
          Icons.person,
          Colors.green,
        ),
        _buildStatItem(
          'Aarti Today',
          stats['aartiCount'].toString(),
          Icons.lightbulb,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsLoading() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildStatsError() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Stats unavailable')),
      ),
    );
  }
}