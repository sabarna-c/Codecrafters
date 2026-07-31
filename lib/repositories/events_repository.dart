import '../core/services/supabase_events_service.dart';
import '../models/event_model.dart';

abstract class IEventsRepository {
  Future<List<EventModel>> getEvents();
  Future<bool> registerRSVP(String eventId, String userId);
  Future<bool> verifyQRCheckIn(String eventId, String qrSecret, String userId);
}

class EventsRepository implements IEventsRepository {
  final SupabaseEventsService _service;

  EventsRepository(this._service);

  @override
  Future<List<EventModel>> getEvents() async {
    return await _service.fetchEvents();
  }

  @override
  Future<bool> registerRSVP(String eventId, String userId) async {
    return await _service.rsvpEvent(eventId, userId);
  }

  @override
  Future<bool> verifyQRCheckIn(String eventId, String qrSecret, String userId) async {
    return await _service.checkInQR(eventId, qrSecret, userId);
  }
}
