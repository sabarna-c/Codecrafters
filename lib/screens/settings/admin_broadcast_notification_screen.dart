import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/admin_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/common/custom_button.dart';

class AdminBroadcastNotificationScreen extends ConsumerStatefulWidget {
  const AdminBroadcastNotificationScreen({super.key});

  @override
  ConsumerState<AdminBroadcastNotificationScreen> createState() => _AdminBroadcastNotificationScreenState();
}

class _AdminBroadcastNotificationScreenState extends ConsumerState<AdminBroadcastNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _targetRole = 'all';

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _handleBroadcast() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(adminRepositoryProvider);
    final success = await repo.sendBroadcastNotification(
      _titleController.text.trim(),
      _bodyController.text.trim(),
      _targetRole,
    );

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, 'Broadcast notification dispatched successfully!');
      context.pop();
    } else {
      SnackbarUtils.showError(context, 'Failed to dispatch broadcast notification.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Broadcast Notification')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Broadcast Announcement', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Send instant FCM push notification to BIT mobile app users.', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                Text('Target Audience', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _targetRole,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Platform Users')),
                    DropdownMenuItem(value: 'student', child: Text('Students Only')),
                    DropdownMenuItem(value: 'alumni', child: Text('Alumni Only')),
                  ],
                  onChanged: (val) => setState(() => _targetRole = val ?? 'all'),
                ),
                const SizedBox(height: 20),
                Text('Notification Title', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (val) => AppValidators.validateRequired(val, 'Title'),
                  decoration: const InputDecoration(hintText: 'e.g. BIT Annual Alumni Meet 2026 Announced!'),
                ),
                const SizedBox(height: 20),
                Text('Notification Body Message', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bodyController,
                  maxLines: 4,
                  validator: (val) => AppValidators.validateRequired(val, 'Message Body'),
                  decoration: const InputDecoration(hintText: 'Enter full notification message content...'),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Send Push Broadcast',
                  onPressed: _handleBroadcast,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
