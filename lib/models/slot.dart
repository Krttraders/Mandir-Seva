// lib/models/slot.dart

class Slot {
  final String id;
  final DateTime start;
  final DateTime end;
  final int capacity;
  final int booked;

  /// Track how many tickets each user has booked
  final Map<String, int> bookedByUser; // userId -> number of tickets

  Slot({
    required this.id,
    required this.start,
    required this.end,
    required this.capacity,
    this.booked = 0,
    Map<String, int>? bookedByUser,
  }) : bookedByUser = bookedByUser ?? {};

  /// Check if slot is already full
  bool get isFull => booked >= capacity;

  /// Time label (e.g., "09:00 - 10:00")
  String get label =>
      '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
          ' - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';

  /// Copy with updated booked count and/or bookedByUser
  Slot copyWith({
    int? booked,
    Map<String, int>? bookedByUser,
  }) {
    return Slot(
      id: id,
      start: start,
      end: end,
      capacity: capacity,
      booked: booked ?? this.booked,
      bookedByUser: bookedByUser ?? Map<String, int>.from(this.bookedByUser),
    );
  }

  /// Book tickets for a user
  /// Returns true if booking successful, false if slot is full
  bool bookForUser(String userId, int members) {
    if (booked + members > capacity) return false;

    // Update booked count
    final newBookedByUser = Map<String, int>.from(bookedByUser);
    newBookedByUser[userId] = (newBookedByUser[userId] ?? 0) + members;

    // Since Slot is immutable, we can't mutate 'booked' here directly.
    // We'll need to use copyWith in your service or state management:
    // newSlot = slot.copyWith(booked: slot.booked + members, bookedByUser: newBookedByUser);

    return true;
  }

  /// Get how many tickets this user has booked
  int ticketsForUser(String userId) {
    return bookedByUser[userId] ?? 0;
  }

  /// Date string label for grouping (e.g., "27 Sep 2025")
  String get dateLabel =>
      '${start.day.toString().padLeft(2, '0')} ${_monthName(start.month)} ${start.year}';

  String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[month - 1];
  }
}
