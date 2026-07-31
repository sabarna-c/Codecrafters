import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/events_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/events/event_card.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BIT Events & Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan QR Attendance',
            onPressed: () => context.push('/events/scan'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(eventsListProvider.future),
        child: eventsAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No Events Scheduled'),
                    Text('Check back soon for new BIT events!'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, i) {
                final event = events[i];
                return EventCard(
                  event: event,
                  onTap: () => context.push('/events/detail', extra: event),
                  onRSVP: () async {
                    final userId = ref.read(authControllerProvider).user?.id ?? 'demo';
                    final repo = ref.read(eventsRepositoryProvider);
                    final ok = await repo.registerRSVP(event.id, userId);
                    if (context.mounted && ok) {
                      SnackbarUtils.showSuccess(context, 'RSVP Confirmed! Your QR pass is ready.');
                    }
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
