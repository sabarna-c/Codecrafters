import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/event_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/events_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/common/custom_button.dart';

class EventDetailScreen extends ConsumerWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat('EEEE, MMMM dd, yyyy • hh:mm a').format(event.eventDate);
    final isPast = event.eventDate.isBefore(DateTime.now());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(shadows: [Shadow(color: Colors.black45, blurRadius: 4)])),
              background: Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR Ticket
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          QrImageView(data: event.qrCodeSecret, size: 160, backgroundColor: Colors.white),
                          const SizedBox(height: 8),
                          const Text('Show this QR at the entrance', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('About This Event', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(event.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
                  const SizedBox(height: 20),
                  _row(Icons.calendar_month_rounded, formattedDate, context),
                  _row(Icons.location_on_rounded, event.location, context),
                  _row(Icons.people_rounded, 'Capacity: ${event.capacity} attendees', context),
                  if (event.isVirtual) _row(Icons.videocam_rounded, 'Virtual Event • Join via Link', context),
                  const SizedBox(height: 28),
                  if (event.isVirtual && event.meetingLink != null)
                    CustomButton(
                      text: 'Join Virtual Event',
                      icon: Icons.video_call_rounded,
                      onPressed: () async {
                        final uri = Uri.parse(event.meetingLink!);
                        if (!await launchUrl(uri) && context.mounted) {
                          SnackbarUtils.showSuccess(context, 'Opening: ${event.meetingLink}');
                        }
                      },
                    ),
                  if (!isPast) ...[
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Confirm RSVP & Download Pass',
                      isSecondary: event.isVirtual,
                      onPressed: () async {
                        final userId = ref.read(authControllerProvider).user?.id ?? 'demo';
                        await ref.read(eventsRepositoryProvider).registerRSVP(event.id, userId);
                        if (context.mounted) {
                          SnackbarUtils.showSuccess(context, 'RSVP confirmed! Show QR code above at the event.');
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
