import 'package:flutter/material.dart';
import 'package:mandirseva/screens/spash_screen.dart';

// Import all required screens
 // The initial screen
import 'package:mandirseva/screens/home_screen.dart';
import 'package:mandirseva/screens/EventsScreen.dart';
import 'package:mandirseva/screens/ScheduleScreen.dart';
import 'package:mandirseva/screens/TempleInfoScreen.dart';
import 'package:mandirseva/screens/booking_screen.dart';
import 'package:mandirseva/screens/notifications_screen.dart';
import 'package:mandirseva/screens/emergency_screen.dart';
import 'package:mandirseva/screens/operator_dashboard.dart';
import 'package:mandirseva/screens/ticket_screen.dart';

void main() {
  runApp(const MandirSevaApp());
}

class MandirSevaApp extends StatelessWidget {
  const MandirSevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MandirSeva',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),

      // The application starts at the root route '/'.
      initialRoute: '/',

      routes: {
        // 1. '/' is mapped to the SplashScreen. This is the first screen the user will see.
        '/': (context) => const SplashScreen(),

        // 2. '/home' is the destination route the SplashScreen navigates to.
        '/home': (context) => const HomeScreen(),

        // Other main routes
        '/notifications': (context) => const NotificationsScreen(),
        '/operator': (context) => const OperatorDashboard(),
        '/booking': (context) => const BookingScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/events': (context) => const EventsScreen(),
        '/info': (context) => const TempleInfoScreen(),
      },

      onGenerateRoute: (settings) {
        // Handle routes that require arguments, like the TicketScreen
        if (settings.name == '/ticket') {
          // Expecting the ticket ID as a String argument
          final args = settings.arguments as String?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (_) => TicketScreen(ticketId: args),
            );
          }
        }
        return null; // For any unknown route
      },
    );
  }
}