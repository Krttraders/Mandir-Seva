import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // REQUIRED for reliable date parsing

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // A simple data model for the events, updated with 2025 dates
  final List<Map<String, dynamic>> _allEvents = [
    {
      // Janmashtami in 2025 - PAST (August 16, 2025)
      'title': 'Janmashtami Celebration',
      'date': 'August 16, 2025',
      'description': 'Lord Krishna birth anniversary special celebrations',
      'imageAsset': 'assets/images/krishna.png',
      'color': Colors.purple,
    },
    {
      // Maha Shivratri in 2025 - PAST (February 26, 2025)
      'title': 'Maha Shivratri',
      'date': 'February 26, 2025',
      'description': 'Night-long prayers and special abhishekam',
      'imageAsset': 'assets/images/shiva.png',
      'color': Colors.blue,
    },
    {
      // Diwali in 2025 - UPCOMING (October 20, 2025)
      'title': 'Diwali Festival',
      'date': 'October 20, 2025',
      'description': 'Festival of lights with special decorations',
      'imageAsset': 'assets/images/diwali.png',
      'color': Colors.amber,
    },
    {
      // Ram Navami in 2025 - PAST (April 6, 2025)
      'title': 'Ram Navami',
      'date': 'April 6, 2025',
      'description': 'Lord Rama birth anniversary celebrations',
      'imageAsset': 'assets/images/rama.png',
      'color': Colors.green,
    },
  ];

  // List to hold the currently displayed events (for filtering)
  late List<Map<String, dynamic>> _filteredEvents;
  String _selectedFilter = 'All'; // State for the filter chip

  @override
  void initState() {
    super.initState();
    // Initially, sort all events by date to show them chronologically
    _allEvents.sort((a, b) => _parseDate(a['date']).compareTo(_parseDate(b['date'])));
    _filteredEvents = _allEvents;
  }

  // Helper function to convert date string to DateTime object for sorting/filtering
  // *** FIXED: Using DateFormat for reliable parsing ***
  DateTime _parseDate(String dateString) {
    try {
      // Define the expected format: "Month Day, Year"
      final dateFormat = DateFormat('MMMM d, yyyy');
      final date = dateFormat.parse(dateString);
      // Return a date-only DateTime object (time set to midnight)
      return DateTime(date.year, date.month, date.day);
    } catch (e) {
      // Fallback for parsing errors
      print('Date Parsing Error for: $dateString - $e');
      return DateTime(2000);
    }
  }

  // Function to handle filtering logic - NOW FULLY WORKING based on 27/09/2025
  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      // Fixed 'current' date for demonstration as requested: September 27, 2025
      // This is a date-only object (time is midnight)
      final now = DateTime(2025, 9, 27);

      if (filter == 'All') {
        _filteredEvents = _allEvents;
      } else if (filter == 'Upcoming') {
        // Upcoming events are those on the same day OR after the 'now' date
        _filteredEvents = _allEvents.where((event) {
          final eventDate = _parseDate(event['date']);
          return eventDate.isAtSameMomentAs(now) || eventDate.isAfter(now);
        }).toList();
      } else if (filter == 'Past') {
        // Past events are those strictly BEFORE the 'now' date
        _filteredEvents = _allEvents.where((event) {
          final eventDate = _parseDate(event['date']);
          return eventDate.isBefore(now);
        }).toList();
      }

      // Ensure the filtered list is also sorted
      _filteredEvents.sort((a, b) => _parseDate(a['date']).compareTo(_parseDate(b['date'])));

      // For 'Past' events, show them in reverse chronological order (most recent past first)
      if (filter == 'Past') {
        _filteredEvents = _filteredEvents.reversed.toList();
      }
    });
  }

  void _onEventTap(String eventTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$eventTitle was tapped!'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
    // You would typically navigate to a details screen here
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(title: eventTitle)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Events - 2025'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Filter Chips Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip('All Events', 'All'),
                const SizedBox(width: 8),
                _buildFilterChip('Upcoming', 'Upcoming'),
                const SizedBox(width: 8),
                _buildFilterChip('Past', 'Past'),
              ],
            ),
          ),
          // --- Event List ---
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
              child: Text(
                'No ${_selectedFilter.toLowerCase()} events found.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return _buildEventCard(
                  title: event['title'],
                  date: event['date'],
                  description: event['description'],
                  imageAsset: event['imageAsset'],
                  color: event['color'],
                  onTap: () => _onEventTap(event['title']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget for Filter Chips ---
  Widget _buildFilterChip(String label, String filter) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == filter,
      onSelected: (bool selected) {
        if (selected) {
          _setFilter(filter);
        }
      },
      selectedColor: Colors.deepOrange.shade100,
      checkmarkColor: Colors.deepOrange,
      labelStyle: TextStyle(
        color: _selectedFilter == filter ? Colors.deepOrange : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // --- Event Card Widget (Unchanged) ---
  Widget _buildEventCard({
    required String title,
    required String date,
    required String description,
    required String imageAsset,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Icon/Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  // Placeholder Icon
                  child: Icon(Icons.star, size: 30, color: color),
                  // child: Image.asset(imageAsset, width: 40, height: 40, color: color),
                ),
              ),
              const SizedBox(width: 16),
              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow Indicator
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 4.0),
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}