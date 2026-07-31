import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/mentorship_provider.dart';
import '../../widgets/mentorship/mentor_request_card.dart';
import '../../core/utils/snackbar_utils.dart';

class MentorRequestsScreen extends ConsumerWidget {
  const MentorRequestsScreen({super.key});

  void _handleStatusChange(BuildContext context, WidgetRef ref, String requestId, String status) {
    if (status == 'accepted') {
      _showMeetingUrlDialog(context, ref, requestId);
    } else {
      ref.read(mentorRequestsNotifierProvider.notifier).updateStatus(requestId, status);
      SnackbarUtils.showSuccess(context, 'Request status updated to $status');
    }
  }

  void _showMeetingUrlDialog(BuildContext context, WidgetRef ref, String requestId) {
    final controller = TextEditingController(text: 'https://meet.google.com/bit-session-demo');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Mentorship Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Google Meet / Zoom link for the session:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'https://meet.google.com/...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(mentorRequestsNotifierProvider.notifier).updateStatus(
                    requestId,
                    'accepted',
                    meetingUrl: controller.text.trim(),
                  );
              Navigator.pop(context);
              SnackbarUtils.showSuccess(context, 'Request accepted! Video meeting link attached.');
            },
            child: const Text('Confirm & Accept'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsState = ref.watch(mentorRequestsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Mentorship Requests')),
      body: requestsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : requestsState.requests.isEmpty
              ? const Center(child: Text('No mentorship requests received.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requestsState.requests.length,
                  itemBuilder: (context, index) {
                    final req = requestsState.requests[index];
                    return MentorRequestCard(
                      request: req,
                      isMentorView: true,
                      onStatusChanged: (newStatus) => _handleStatusChange(context, ref, req.id, newStatus),
                    );
                  },
                ),
    );
  }
}
