import 'package:calendar_app/events.dart';
import 'package:calendar_app/models/event.dart';

class EventService {
  List<Event> getEvents() {
    return eventsRaw.map((json) => Event.fromJson(json)).toList();
  }
}
