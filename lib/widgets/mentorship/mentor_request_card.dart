import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/mentor_request_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/snackbar_utils.dart';

class MentorRequestCard extends StatelessWidget {
  final MentorRequestModel request;
  final Function(String status)? onStatusChanged;
  final bool isMentorView;

  const MentorRequestCard({
    super.key,
    required this.request,
    this.onStatusChanged,
    this.isMentorView = false,
  });

  Color _getStatusColor() {
    if (request.isAccepted) return AppColors.secondaryEmerald;
    if (request.isRejected) return AppColors.errorCrimson;
    if (request.isCompleted) return AppColors.primaryBlue;
    return AppColors.accentAmber;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(request.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isMentorView ? 'Student: ${request.studentName}' : 'Mentor: ${request.mentorName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withAlpha(60)),
                  ),
                  child: Text(
                    request.status.toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Requested on $formattedDate',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (request.isAccepted && request.meetingUrl != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(request.meetingUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    if (context.mounted) {
                      SnackbarUtils.showSuccess(context, 'Joining meeting: ${request.meetingUrl}');
                    }
                  }
                },
                icon: const Icon(Icons.video_call_rounded, color: AppColors.secondaryEmerald),
                label: const Text('Join Video Call'),
              ),
            ],
            if (isMentorView && request.isPending && onStatusChanged != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onStatusChanged!('rejected'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.errorCrimson),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onStatusChanged!('accepted'),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
