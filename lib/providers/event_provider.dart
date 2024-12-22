import 'package:calendar_app/service/event_service.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class EventProvider with ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => [..._events];

  EventProvider() {
    final eventService = EventService();
    _events.addAll(eventService.getEvents());
    notifyListeners();
  }
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }
}
