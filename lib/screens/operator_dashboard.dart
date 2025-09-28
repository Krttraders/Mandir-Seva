import 'package:flutter/material.dart';

// --- Mock Data Service (Included for completeness) ---

class Slot {
  final String id;
  final String label;
  final int capacity;
  final int booked;

  Slot({required this.id, required this.label, required this.capacity, required this.booked});

  double get progress => booked / capacity;
}

class DashboardData {
  final int totalBookings;
  final int pendingVerification;
  final int criticalAlerts;
  final int totalSlots;

  DashboardData({
    required this.totalBookings,
    required this.pendingVerification,
    required this.criticalAlerts,
    required this.totalSlots,
  });
}

class MockService {
  static final List<Slot> slots = [
    Slot(id: 'S01', label: 'Morning Darshan 6-8 AM', capacity: 100, booked: 85),
    Slot(id: 'S02', label: 'Aarti 8-9 AM', capacity: 50, booked: 48),
    Slot(id: 'S03', label: 'Mid-day 12-2 PM', capacity: 150, booked: 30),
    Slot(id: 'S04', label: 'Evening Aarti 6-7 PM', capacity: 75, booked: 75),
  ];

  static final DashboardData dashboardData = DashboardData(
    totalBookings: 2355,
    pendingVerification: 12,
    criticalAlerts: 3,
    totalSlots: slots.length,
  );
}

// ---------------------------------------------------

class OperatorDashboard extends StatelessWidget {
  const OperatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final slots = MockService.slots;
    final data = MockService.dashboardData;
    // FIX: Define primaryColor as MaterialColor to enable .shade properties
    const MaterialColor primaryColor = Colors.deepOrange;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Temple Operator Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Key Performance Indicators (KPIs) ---
            _buildSectionTitle("Quick Overview"),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildInfoCard(
                  context,
                  title: 'Total Bookings',
                  value: data.totalBookings.toString(),
                  icon: Icons.bookmark_added,
                  // Fixed: .shade600 is now accessible
                  color: Colors.blue.shade600,
                ),
                _buildInfoCard(
                  context,
                  title: 'Pending Verify',
                  value: data.pendingVerification.toString(),
                  icon: Icons.pending_actions,
                  // Fixed: .shade600 is now accessible
                  color: primaryColor.shade600,
                ),
                _buildInfoCard(
                  context,
                  title: 'Critical Alerts',
                  value: data.criticalAlerts.toString(),
                  icon: Icons.warning_amber,
                  // Fixed: .shade600 is now accessible
                  color: Colors.red.shade600,
                ),
                _buildInfoCard(
                  context,
                  title: 'Total Slots',
                  value: data.totalSlots.toString(),
                  icon: Icons.access_time_filled,
                  // Fixed: .shade600 is now accessible
                  color: Colors.teal.shade600,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- 2. Actionable Items ---
            _buildSectionTitle("Action Center"),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildActionTile(
                    context,
                    title: "Verify Darshan Requests",
                    subtitle: "Approve or reject ${data.pendingVerification} pending bookings.",
                    icon: Icons.verified_user,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showSnackbar(context, "Navigating to Verification Panel"),
                    color: primaryColor,
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _buildActionTile(
                    context,
                    title: "Live Camera Feed",
                    subtitle: "Monitor temple premises and main areas.",
                    icon: Icons.videocam,
                    onTap: () => _showSnackbar(context, "Connecting to Live Feed"),
                    color: Colors.green,
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _buildActionTile(
                    context,
                    title: "View System Alerts",
                    subtitle: "Review ${data.criticalAlerts} critical system messages.",
                    icon: Icons.notifications_active,
                    onTap: () => _showSnackbar(context, "Navigating to Alert Panel"),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 3. Detailed Slot Management ---
            _buildSectionTitle("Current Slot Status"),
            const SizedBox(height: 12),
            ...slots.map((s) => _buildSlotStatusTile(context, s)).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required String title, required String subtitle, required IconData icon, VoidCallback? onTap, Widget? trailing, required Color color}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSlotStatusTile(BuildContext context, Slot slot) {
    final bool isFull = slot.progress >= 1.0;
    final Color progressColor = isFull ? Colors.red : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slot.label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: slot.progress,
                backgroundColor: Colors.grey[300],
                color: progressColor,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booked: ${slot.booked} / ${slot.capacity}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  Text(
                    isFull ? 'CAPACITY FULL' : '${(slot.progress * 100).toStringAsFixed(0)}% Booked',
                    style: TextStyle(
                      color: progressColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}