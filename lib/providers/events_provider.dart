import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_events_service.dart';
import '../repositories/events_repository.dart';
import '../models/event_model.dart';

final eventsServiceProvider = Provider<SupabaseEventsService>((ref) {
  return SupabaseEventsService(Supabase.instance.client);
});

final eventsRepositoryProvider = Provider<IEventsRepository>((ref) {
  final service = ref.watch(eventsServiceProvider);
  return EventsRepository(service);
});

final eventsListProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.watch(eventsRepositoryProvider);
  return await repo.getEvents();
});
