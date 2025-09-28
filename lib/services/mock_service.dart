// lib/services/mock_service.dart

import '../models/slot.dart';
import 'dart:math';

class MockService {
  // ====== Slot Management ======
  static final List<Slot> slots = [
    Slot(
      id: "1",
      start: DateTime(2025, 1, 1, 9, 0),
      end: DateTime(2025, 1, 1, 10, 0),
      capacity: 50,
      booked: 20,
    ),
    Slot(
      id: "2",
      start: DateTime(2025, 1, 1, 10, 0),
      end: DateTime(2025, 1, 1, 11, 0),
      capacity: 50,
      booked: 35,
    ),
    Slot(
      id: "3",
      start: DateTime(2025, 1, 1, 11, 0),
      end: DateTime(2025, 1, 1, 12, 0),
      capacity: 50,
      booked: 50,
    ),
  ];

  /// Book a slot for a user with multiple members
  /// Returns random 8-digit ticket ID or 'FULL' if overbooked
  static String bookSlot(Slot slot, String userId, [int members = 1]) {
    final index = slots.indexWhere((s) => s.id == slot.id);
    if (index == -1) return 'FULL';

    final selectedSlot = slots[index];

    if (selectedSlot.booked + members > selectedSlot.capacity) {
      return 'FULL';
    }

    // Update bookedByUser map
    final newBookedByUser = Map<String, int>.from(selectedSlot.bookedByUser);
    newBookedByUser[userId] = (newBookedByUser[userId] ?? 0) + members;

    // Update slot with copyWith
    slots[index] = selectedSlot.copyWith(
      booked: selectedSlot.booked + members,
      bookedByUser: newBookedByUser,
    );

    // Generate random 8-digit ticket ID
    return (10000000 + Random().nextInt(89999999)).toString();
  }

  /// Reset all bookings (for testing)
  static void resetBookings() {
    for (var i = 0; i < slots.length; i++) {
      slots[i] = slots[i].copyWith(
        booked: 0,
        bookedByUser: {},
      );
    }
  }

  // ====== Crowd Density Simulation ======
  /// Returns "Low" / "Medium" / "High"
  static String getCrowdDensity() {
    final options = ["Low", "Medium", "High"];
    return options[Random().nextInt(options.length)];
  }

  /// Returns crowd density by zones (values between 0.0 - 1.0)
  static Map<String, double> getZoneDensityMap() {
    return {
      "Zone A": Random().nextDouble(),
      "Zone B": Random().nextDouble(),
      "Zone C": Random().nextDouble(),
      "Zone D": Random().nextDouble(),
    };
  }

  /// Alias for backward compatibility
  static Map<String, double> getZoneDensity() => getZoneDensityMap();

  // ====== Temple Stats ======
  static Map<String, int> getTempleStats() {
    return {
      'visitorsToday': 1247,
      'liveVisitors': 89,
      'aartiCount': 5,
      'donationsToday': 45230,
    };
  }

  // ====== Live Darshan Cameras ======
  static List<Map<String, dynamic>> getLiveDarshanCameras() {
    return [
      {'name': 'Sanctum Sanctorum', 'viewers': 125, 'isLive': true},
      {'name': 'Main Hall', 'viewers': 89, 'isLive': true},
      {'name': 'Entrance', 'viewers': 42, 'isLive': true},
    ];
  }

  // ====== Upcoming Events ======
  static List<Map<String, dynamic>> getUpcomingEvents() {
    return [
      {'title': 'Morning Aarti', 'time': '06:00 AM', 'date': 'Today', 'type': 'Daily'},
      {'title': 'Special Pooja', 'time': '11:00 AM', 'date': 'Today', 'type': 'Special'},
      {'title': 'Bhajan Session', 'time': '06:00 PM', 'date': 'Today', 'type': 'Weekly'},
    ];
  }
}
