import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// --- MOCK TICKET DATA (Simulating a database lookup) ---
// In a real app, this data would be fetched from a service using the ticketId.
final Map<String, Map<String, String>> _mockTicketDetails = {
  'TICKET-12345': {
    'date': 'Sunday, 28 September',
    'time': '10:00 AM - 11:00 AM',
    'purpose': 'Morning Darshan',
    'passengers': '2 Adults',
  },
  'TICKET-67890': {
    'date': 'Monday, 29 September',
    'time': '05:00 PM - 06:00 PM',
    'purpose': 'Evening Aarti',
    'passengers': '1 Adult, 1 Child',
  },
  // Add more mock data as needed
};

// Fallback data if the ID isn't found in the mock map
const Map<String, String> _defaultTicketDetails = {
  'date': 'Date and Time Slot',
  'time': 'Specific Time Window',
  'purpose': 'Temple Entry Pass',
  'passengers': 'Capacity Details',
};

class TicketScreen extends StatelessWidget {
  final String ticketId;

  const TicketScreen({super.key, required this.ticketId});

  // Helper method to retrieve ticket details from the mock data
  Map<String, String> _getTicketDetails() {
    return _mockTicketDetails[ticketId] ?? _defaultTicketDetails;
  }

  // --- NEW: Detail Row Widget ---
  Widget _buildDetailRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketDetails = _getTicketDetails();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Digital Pass"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // --- Ticket Card ---
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        "Your Booking is Confirmed!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- QR Code Area ---
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: ticketId,
                          version: QrVersions.auto,
                          size: 180.0,
                          // Customize QR color
                          eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: primaryColor),
                          dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Ticket ID and Instructions ---
                      Text(
                        "PASS ID: $ticketId",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const Divider(height: 30),

                      // --- Detailed Information ---
                      _buildDetailRow(
                        "Date of Visit",
                        ticketDetails['date']!,
                        Icons.calendar_today,
                        Colors.green.shade700,
                      ),
                      _buildDetailRow(
                        "Time Slot",
                        ticketDetails['time']!,
                        Icons.access_time_filled,
                        Colors.blue.shade700,
                      ),
                      _buildDetailRow(
                        "Purpose",
                        ticketDetails['purpose']!,
                        Icons.account_balance,
                        Colors.purple.shade700,
                      ),
                      _buildDetailRow(
                        "Capacity",
                        ticketDetails['passengers']!,
                        Icons.people_alt,
                        Colors.orange.shade700,
                      ),
                      const Divider(height: 30),

                      // --- Instruction for Scanning ---
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Present this QR code for scanning at the designated entry point.",
                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- Action Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate back to the very first screen (usually home/slot booking)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text("Go to Home Screen", style: TextStyle(fontSize: 16, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}