import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Column(
        children: [
          Center(
            child: Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Date & Time: ${DateFormat('yMMMd').add_jm().format(event.dateTime)}',
            style: const TextStyle(fontSize: 18),
          ),
          Text('Location: ${event.locationName}',
              style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
