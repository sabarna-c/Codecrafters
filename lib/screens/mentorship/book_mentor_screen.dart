import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/mentor_model.dart';
import '../../providers/mentorship_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/common/custom_button.dart';

class BookMentorScreen extends ConsumerStatefulWidget {
  final MentorModel mentor;

  const BookMentorScreen({
    super.key,
    required this.mentor,
  });

  @override
  ConsumerState<BookMentorScreen> createState() => _BookMentorScreenState();
}

class _BookMentorScreenState extends ConsumerState<BookMentorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleBooking() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authControllerProvider).user;
    final profile = ref.read(authControllerProvider).profile;
    final studentName = profile?.fullName ?? user?.email ?? 'BIT Student';

    final notifier = ref.read(mentorRequestsNotifierProvider.notifier);
    final success = await notifier.bookSession(
      mentorId: widget.mentor.id,
      studentName: studentName,
      message: '${_messageController.text.trim()}\nPreferred Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
    );

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, 'Mentorship session requested successfully!');
      context.pop();
    } else {
      SnackbarUtils.showError(context, 'Failed to send mentorship request.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Session: ${widget.mentor.fullName}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request 1-on-1 Mentorship',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.mentor.jobTitle} at ${widget.mentor.company}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Text('Select Preferred Date', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Icon(Icons.calendar_month_rounded, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Session Agenda & Questions', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  validator: (val) => AppValidators.validateRequired(val, 'Session Agenda'),
                  decoration: const InputDecoration(
                    hintText: 'Describe what you would like to discuss (e.g. resume review, system design preparation, career transition advice)...',
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Submit Booking Request',
                  onPressed: _handleBooking,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
