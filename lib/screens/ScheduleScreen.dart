import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat

// --- TEMPLE DATA STRUCTURE ---
class TempleSchedule {
  final String templeName;
  final String location;
  final String openingTime;
  final String closingTime;
  final List<Map<String, String>> dailyEvents;

  const TempleSchedule({
    required this.templeName,
    required this.location,
    required this.openingTime,
    required this.closingTime,
    required this.dailyEvents,
  });
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Complete Temple Data Map with all 10 temples
  static final Map<String, TempleSchedule> _templeData = {
    'Kashi Vishwanath': TempleSchedule(
      templeName: 'Shri Kashi Vishwanath Temple',
      location: 'Varanasi, UP',
      openingTime: '2:30 AM',
      closingTime: '11:00 PM',
      dailyEvents: [
        {'time': '3:00 AM - 4:00 AM', 'event': 'Mangala Aarti', 'description': 'Morning rituals (Paid/Special Pass)'},
        {'time': '4:00 AM - 11:00 AM', 'event': 'General Darshan', 'description': 'Free Darshan for public'},
        {'time': '11:15 AM - 12:20 PM', 'event': 'Bhog Aarti', 'description': 'Mid-day offering rituals'},
        {'time': '12:00 PM - 7:00 PM', 'event': 'Free Darshan', 'description': 'General public darshan continues'},
        {'time': '7:00 PM - 8:15 PM', 'event': 'Sapta Rishi/Sandhya Aarti', 'description': 'No darshan during this time'},
        {'time': '9:00 PM - 10:15 PM', 'event': 'Shringar Aarti', 'description': 'Dress up ritual'},
        {'time': '10:30 PM - 11:00 PM', 'event': 'Shayan Aarti', 'description': 'Closing rituals'},
      ],
    ),
    'Brihadeeswara Temple': TempleSchedule(
      templeName: 'Brihadeeswara Temple',
      location: 'Thanjavur, TN',
      openingTime: '6:00 AM',
      closingTime: '8:30 PM',
      dailyEvents: [
        {'time': '6:00 AM - 12:30 PM', 'event': 'Morning Darshan', 'description': 'Temple is open for public'},
        {'time': '8:30 AM', 'event': 'Palabhishekam', 'description': 'Abhishekam with milk'},
        {'time': '12:00 PM', 'event': 'Vucha Kalai Pooja', 'description': 'Mid-day pooja'},
        {'time': '12:30 PM - 4:00 PM', 'event': 'Afternoon Break', 'description': 'Mandir closed'},
        {'time': '4:00 PM - 8:30 PM', 'event': 'Evening Darshan', 'description': 'Temple re-opens after break'},
        {'time': '6:00 PM', 'event': 'Sai Rakchay Pooja', 'description': 'Evening protection pooja'},
        {'time': '8:30 PM', 'event': 'Arthajamam', 'description': 'Final rituals before closing'},
      ],
    ),
    'Padmanabhaswamy': TempleSchedule(
      templeName: 'Sree Padmanabhaswamy Temple',
      location: 'Thiruvananthapuram, Kerala',
      openingTime: '3:15 AM',
      closingTime: '7:20 PM',
      dailyEvents: [
        {'time': '3:15 AM - 4:15 AM', 'event': 'Early Morning Darshan', 'description': 'Special morning slot'},
        {'time': '6:30 AM - 7:00 AM', 'event': 'Morning Darshan', 'description': 'Public Darshan'},
        {'time': '8:30 AM - 10:00 AM', 'event': 'Morning Darshan', 'description': 'Public Darshan'},
        {'time': '10:30 AM - 11:10 AM', 'event': 'Morning Darshan', 'description': 'Public Darshan'},
        {'time': '11:45 AM - 12:00 PM', 'event': 'Morning Darshan', 'description': 'Last morning slot'},
        {'time': '5:00 PM - 6:15 PM', 'event': 'Evening Darshan', 'description': 'Public Darshan'},
        {'time': '6:45 PM - 7:20 PM', 'event': 'Evening Darshan', 'description': 'Last public slot'},
      ],
    ),
    'Jagannatha Puri': TempleSchedule(
      templeName: 'Shree Jagannatha Temple',
      location: 'Puri, Odisha',
      openingTime: '5:30 AM',
      closingTime: '9:00 PM',
      dailyEvents: [
        {'time': '5:00 AM', 'event': 'Mangal Aarti', 'description': 'Temple opens for early darshan'},
        {'time': '6:00 AM - 7:30 AM', 'event': 'Morning General Darshan', 'description': 'Public darshan'},
        {'time': '8:00 AM - 9:15 AM', 'event': 'Gopal Ballava Puja', 'description': 'No darshan during this time'},
        {'time': '9:15 AM - 11:00 AM', 'event': 'Sakala Dhupa Darshan', 'description': 'Morning offering darshan'},
        {'time': '11:00 AM - 1:00 PM', 'event': 'Bhoga Mandap Darshan', 'description': 'Mahaprasad distribution'},
        {'time': '1:00 PM - 4:00 PM', 'event': 'Afternoon Break', 'description': 'Temple closed for cleaning'},
        {'time': '4:00 PM - 5:30 PM', 'event': 'Evening Darshan', 'description': 'Afternoon Darshan (Madhyanna Dhupa)'},
        {'time': '6:00 PM - 8:00 PM', 'event': 'Sandhya Dhupa and Aarti', 'description': 'Evening rituals and darshan'},
        {'time': '9:00 PM - 10:00 PM', 'event': 'Final Darshan', 'description': 'Badasinghara Bhoga and last darshan'},
      ],
    ),
    'Somnath Temple': TempleSchedule(
      templeName: 'Somnath Temple',
      location: 'Veraval, Gujarat',
      openingTime: '6:00 AM',
      closingTime: '9:00 PM',
      dailyEvents: [
        {'time': '6:00 AM - 12:00 PM', 'event': 'General Darshan', 'description': 'Darshan is continuous'},
        {'time': '7:00 AM', 'event': 'Mangala Aarti', 'description': 'Morning Aarti'},
        {'time': '12:00 PM', 'event': 'Rajbhog Aarti', 'description': 'Noon offerings'},
        {'time': '12:00 PM - 7:00 PM', 'event': 'General Darshan', 'description': 'Darshan is continuous'},
        {'time': '7:00 PM', 'event': 'Sandhya Aarti', 'description': 'Evening prayers'},
        {'time': '8:00 PM', 'event': 'Shayan Aarti', 'description': 'Night prayers and closing'},
      ],
    ),
    'Sun Temple Konark': TempleSchedule(
      templeName: 'Sun Temple',
      location: 'Konark, Odisha',
      openingTime: '6:00 AM',
      closingTime: '8:00 PM',
      dailyEvents: [
        {'time': '6:00 AM - 8:00 PM', 'event': 'General Visit', 'description': 'Temple open for visitors'},
        {'time': 'All Day', 'event': 'Open Daily', 'description': 'No weekly closure'},
      ],
    ),
    'Meenakshi Amman Temple': TempleSchedule(
      templeName: 'Meenakshi Amman Temple',
      location: 'Madurai, Tamil Nadu',
      openingTime: '5:00 AM',
      closingTime: '10:00 PM',
      dailyEvents: [
        {'time': '5:00 AM - 12:30 PM', 'event': 'Morning Session', 'description': 'Temple open for darshan'},
        {'time': '7:15 AM - 10:30 AM', 'event': 'Morning Darshan', 'description': 'Main darshan timing'},
        {'time': '11:15 AM - 12:30 PM', 'event': 'Afternoon Darshan', 'description': 'Before lunch break'},
        {'time': '12:30 PM - 4:00 PM', 'event': 'Afternoon Break', 'description': 'Temple closed'},
        {'time': '4:00 PM - 10:00 PM', 'event': 'Evening Session', 'description': 'Temple re-opens'},
        {'time': '4:30 PM - 7:30 PM', 'event': 'Evening Darshan', 'description': 'Main evening darshan'},
        {'time': '8:15 PM - 9:30 PM', 'event': 'Night Darshan', 'description': 'Final darshan of the day'},
      ],
    ),
    'Birla Mandir Delhi': TempleSchedule(
      templeName: 'Shri Laxmi Narayan Temple (Birla Mandir)',
      location: 'Delhi',
      openingTime: '4:30 AM',
      closingTime: '9:00 PM',
      dailyEvents: [
        {'time': '4:30 AM - 1:30 PM', 'event': 'Morning Session', 'description': 'Temple open for darshan'},
        {'time': '6:00 AM', 'event': 'Morning Aarti', 'description': 'Daily morning rituals'},
        {'time': '1:30 PM - 2:30 PM', 'event': 'Afternoon Break', 'description': 'Temple closed'},
        {'time': '2:30 PM - 9:00 PM', 'event': 'Evening Session', 'description': 'Temple re-opens'},
        {'time': '6:45 PM', 'event': 'Sandhya Aarti', 'description': 'Evening prayers'},
      ],
    ),
    'Vaishno Devi Temple': TempleSchedule(
      templeName: 'Vaishno Devi Temple',
      location: 'Katra, Jammu and Kashmir',
      openingTime: '5:00 AM',
      closingTime: '9:00 PM',
      dailyEvents: [
        {'time': '5:00 AM - 12:00 PM', 'event': 'Morning Darshan', 'description': 'Temple open for pilgrims'},
        {'time': '6:00 AM - 8:00 AM', 'event': 'Morning Aarti', 'description': 'Darshan closed during aarti'},
        {'time': '12:00 PM - 4:00 PM', 'event': 'Temple Break', 'description': 'Temple closed for maintenance'},
        {'time': '4:00 PM - 9:00 PM', 'event': 'Evening Darshan', 'description': 'Temple re-opens'},
        {'time': '6:00 PM - 8:00 PM', 'event': 'Evening Aarti', 'description': 'Darshan closed during aarti'},
      ],
    ),
    'Tirupati Balaji': TempleSchedule(
      templeName: 'Sri Venkateswara Swamy Temple (Tirupati Balaji)',
      location: 'Tirumala, Andhra Pradesh',
      openingTime: '1:00 AM',
      closingTime: '12:00 AM',
      dailyEvents: [
        {'time': '1:00 AM - 12:00 AM', 'event': 'Temple Open', 'description': 'Open 23 hours daily'},
        {'time': '8:30 AM - 11:30 PM', 'event': 'Sarva Darshan (Free)', 'description': 'Free darshan for all'},
        {'time': '12:00 PM - 6:00 PM', 'event': 'Special Entry Darshan', 'description': 'Paid darshan (₹300)'},
        {'time': '10:00 AM', 'event': 'Senior Citizen Darshan', 'description': 'For elderly and physically challenged'},
        {'time': '3:00 PM', 'event': 'Physically Challenged Darshan', 'description': 'Special assistance available'},
        {'time': '10:30 AM - 12:00 PM', 'event': 'Infant Darshan', 'description': 'For children below 1 year'},
        {'time': '12:00 PM - 6:00 PM', 'event': 'NRI Darshan', 'description': 'For non-resident Indians'},
      ],
    ),
  };

  // State to hold the currently selected temple's key
  String? _selectedTempleKey = 'Kashi Vishwanath'; // Default selection

  // Helper to get the schedule object
  TempleSchedule? get _currentSchedule => _templeData[_selectedTempleKey];

  // DateFormat pattern for parsing the time strings (e.g., '2:30 AM')
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  /// Converts a time string (e.g., '2:30 AM') into a DateTime object,
  /// setting the date part to today for comparison.
  DateTime _parseTime(String time) {
    try {
      // Parse the time using the specified format
      final timeOfDay = _timeFormat.parse(time);

      // Get today's date
      final now = DateTime.now();

      // Combine today's date with the parsed time
      return DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    } catch (e) {
      // Fallback for tricky data like "12:00 AM" or "12:00 PM" if the formatter struggles
      // Using a known base date for consistency
      return _timeFormat.parse(time);
    }
  }

  // FIX: Updated function for accurate calculation using DateTime and Duration
  String _calculateOpenHours(TempleSchedule schedule) {
    // Special case for Tirupati Balaji which is essentially 23 hours a day
    if (schedule.templeName.contains('Tirupati Balaji')) {
      return '23 hours';
    }

    try {
      DateTime openTime = _parseTime(schedule.openingTime);
      DateTime closeTime = _parseTime(schedule.closingTime);

      // If the closing time is earlier than the opening time, it means the temple closes
      // on the next day (e.g., opens 2:30 AM, closes 11:00 PM the same day, so closingTime > openingTime.
      // But if it was 11:00 PM open and 2:30 AM close, then closeTime < openTime).
      // Since all your temples open very early AM and close late PM, closeTime should be greater.
      // The Sun Temple is open from 6:00 AM to 8:00 PM (14 hours)
      // The logic below ensures that if the closing time is earlier than the opening time,
      // it treats it as the next day's time.
      if (closeTime.isBefore(openTime)) {
        // Assume closing is on the next day, add 24 hours to closing time.
        closeTime = closeTime.add(const Duration(days: 1));
      }

      final Duration duration = closeTime.difference(openTime);
      final int totalMinutes = duration.inMinutes;

      final int hours = totalMinutes ~/ 60; // Integer division for hours
      final int minutes = totalMinutes % 60; // Remainder for minutes

      if (minutes == 0) {
        return '$hours hours';
      } else {
        return '$hours hrs $minutes min';
      }
    } catch (e) {
      // Log error for debugging if needed
      // print('Time calculation error: $e');
      return 'Varied or Check Locally';
    }
  }

  // Temple Selection Bottom Sheet
  void _showTempleSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select a Temple',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: _templeData.keys.map((key) {
                    return ListTile(
                      // Corrected Icon
                      leading: Icon(Icons.temple_buddhist, color: Theme.of(context).primaryColor),
                      title: Text(
                        _templeData[key]!.templeName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(_templeData[key]!.location),
                      trailing: _selectedTempleKey == key
                          ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedTempleKey = key;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Schedule Card Widget
  Widget _buildScheduleCard({
    required String time,
    required String event,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // General Info Widget
  Widget _buildGeneralInfo(TempleSchedule schedule) {
    return Card(
      color: Colors.deepOrange.shade50,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(Icons.login, 'Opens', schedule.openingTime, Colors.green),
                _buildInfoChip(Icons.logout, 'Closes', schedule.closingTime, Colors.red),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total Open Hours: ${_calculateOpenHours(schedule)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String title, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _currentSchedule;

    return Scaffold(
      appBar: AppBar(
        title: Text(schedule != null ? schedule.templeName : 'Temple Schedule'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showTempleSelector,
            icon: const Icon(Icons.location_city),
            tooltip: 'Select Temple',
          ),
        ],
      ),
      body: schedule == null
          ? const Center(child: Text("Please select a temple schedule."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Header
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.deepOrange.shade700, size: 20),
                const SizedBox(width: 4),
                Text(
                  schedule.location,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // General Opening/Closing Info
            _buildGeneralInfo(schedule),

            const Divider(),
            const SizedBox(height: 10),

            // Schedule Header
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.deepOrange.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Daily Ritual & Darshan Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Dynamic Schedule List
            ...schedule.dailyEvents.map((event) {
              return _buildScheduleCard(
                time: event['time']!,
                event: event['event']!,
                description: event['description']!,
              );
            }).toList(),

            const SizedBox(height: 20),
            // Footer note (UPDATED)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Please note: All displayed timings are subject to change on festivals or special occasions. Any confirmed official updates will be reflected here.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// You can wrap ScheduleScreen in a MaterialApp and run it in your main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temple Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const ScheduleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}