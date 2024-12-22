import 'package:flutter/material.dart';
import '../models/event.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Column(
        children: [
          Text('Date & Time: ${event.dateTime}'),
          Text('Location: ${event.locationName}'),
          ElevatedButton(
            child: const Text('Navigate to Event'),
            onPressed: () {
              // Implement navigation to event location
            },
          ),
        ],
      ),
    );
  }
}
