import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> messages = [
      "Your slot at 10:00 AM is confirmed.",
      "Overcrowding alert near main gate.",
      "Temple will close at 8 PM today.",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(messages[index]),
          );
        },
      ),
    );
  }
}
