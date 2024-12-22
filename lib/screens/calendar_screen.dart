import 'package:calendar_app/screens/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import './map_screen.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Schedule')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(events[i].title),
          subtitle: Text('${events[i].dateTime} - ${events[i].locationName}'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EventDetailsScreen(event: events[i]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MapScreen()),
          );
        },
      ),
    );
  }
}
