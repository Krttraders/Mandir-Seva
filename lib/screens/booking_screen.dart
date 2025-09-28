// lib/screens/booking_screen.dart

import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import '../models/slot.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

enum SlotFilter { all, available, full }

class _BookingScreenState extends State<BookingScreen> {
  SlotFilter _selectedFilter = SlotFilter.all;
  final String currentUserId = 'USER123'; // Local mock user ID

  // Check if a slot is today
  bool _isToday(Slot slot) {
    final today = DateTime.now();
    return slot.start.day == today.day &&
        slot.start.month == today.month &&
        slot.start.year == today.year;
  }

  // Confirm booking with member count
  void _confirmAndBook(BuildContext context, Slot slot) async {
    int maxMembers = slot.capacity - slot.booked;
    if (maxMembers <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This slot is already full!')),
      );
      return;
    }

    int members = 1;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirm Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Slot: ${slot.label}'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (members > 1) setState(() => members--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$members',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        if (members < maxMembers) setState(() => members++);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                    'Capacity: ${slot.booked}/${slot.capacity} (You can book up to $maxMembers)'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Book')),
            ],
          );
        });
      },
    );

    if (confirmed == true) {
      _bookSlot(context, slot, members);
    }
  }

  void _bookSlot(BuildContext context, Slot slot, int members) {
    final ticketId = MockService.bookSlot(slot, currentUserId, members);

    if (ticketId == 'FULL') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sorry, this slot is now full!')),
      );
    } else {
      setState(() {}); // Refresh UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful! Ticket: $ticketId')),
      );
    }
  }

  // Filter slots
  List<Slot> _getFilteredSlots(List<Slot> allSlots) {
    switch (_selectedFilter) {
      case SlotFilter.available:
        return allSlots.where((slot) => !slot.isFull).toList();
      case SlotFilter.full:
        return allSlots.where((slot) => slot.isFull).toList();
      case SlotFilter.all:
      default:
        return allSlots;
    }
  }

  Widget _buildFilterChip(String label, SlotFilter filter) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedFilter = filter);
        },
        selectedColor: Colors.green.shade100,
      ),
    );
  }

  Widget _buildCapacityBar(Slot slot) {
    final percentage = slot.booked / slot.capacity;
    Color color;
    if (percentage >= 0.9) {
      color = Colors.red;
    } else if (percentage >= 0.7) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: percentage,
        minHeight: 8,
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSlots = MockService.slots;
    final filteredSlots = _getFilteredSlots(allSlots);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Darshan Pass"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _buildFilterChip("All", SlotFilter.all),
                _buildFilterChip("Available", SlotFilter.available),
                _buildFilterChip("Full", SlotFilter.full),
              ],
            ),
          ),
          const Divider(height: 1),
          // Slot List
          Expanded(
            child: filteredSlots.isEmpty
                ? const Center(child: Text("No slots found"))
                : ListView.builder(
              itemCount: filteredSlots.length,
              itemBuilder: (context, index) {
                final slot = filteredSlots[index];
                final userBooked =
                    slot.bookedByUser[currentUserId] ?? 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          slot.isFull
                              ? Icons.lock_clock
                              : Icons.access_time,
                          color: slot.isFull ? Colors.red : Colors.green,
                        ),
                        title: Text(slot.label),
                        subtitle: Text(
                            "Booked: ${slot.booked}/${slot.capacity} | Your Booking: $userBooked"),
                        trailing: slot.isFull
                            ? const Text("Full",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold))
                            : ElevatedButton(
                          onPressed: () =>
                              _confirmAndBook(context, slot),
                          child: const Text("Book Now"),
                        ),
                      ),
                      Padding(
                          padding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: _buildCapacityBar(slot)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
