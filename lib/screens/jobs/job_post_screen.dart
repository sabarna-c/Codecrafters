import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/job_model.dart';
import '../../providers/jobs_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/common/custom_button.dart';

class JobPostScreen extends ConsumerStatefulWidget {
  const JobPostScreen({super.key});

  @override
  ConsumerState<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends ConsumerState<JobPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _linkController = TextEditingController();

  String _jobType = 'Full-Time';
  String _expLevel = 'Entry Level';
  bool _acceptsReferrals = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final job = JobModel(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      company: _companyController.text.trim(),
      location: _locationController.text.trim(),
      jobType: _jobType,
      experienceLevel: _expLevel,
      description: _descriptionController.text.trim(),
      salaryRange: _salaryController.text.isNotEmpty ? _salaryController.text.trim() : null,
      applyLink: _linkController.text.isNotEmpty ? _linkController.text.trim() : null,
      acceptsReferrals: _acceptsReferrals,
      createdAt: DateTime.now(),
    );

    final userId = ref.read(authControllerProvider).user?.id ?? 'demo_alumni';
    final repo = ref.read(jobsRepositoryProvider);
    await repo.postJob(job, userId);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    SnackbarUtils.showSuccess(context, 'Job Opportunity Published!');
    ref.invalidate(jobsListProvider);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job Opportunity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title *', hintText: 'e.g. Senior Software Engineer'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name *', hintText: 'e.g. Google'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Company is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location *', hintText: 'e.g. Mountain View, CA (Hybrid)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Location is required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _jobType,
                      decoration: const InputDecoration(labelText: 'Job Type'),
                      items: ['Full-Time', 'Part-Time', 'Contract', 'Internship']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _jobType = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _expLevel,
                      decoration: const InputDecoration(labelText: 'Experience'),
                      items: ['Entry Level', 'Mid Level', 'Senior', 'Lead / Staff']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _expLevel = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Role Description *', hintText: 'Outline responsibilities and requirements...'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary Range (Optional)', hintText: 'e.g. \$120,000 – \$150,000'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(labelText: 'Application URL (Optional)', hintText: 'https://careers.company.com/job/123'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Accept Referral Requests'),
                subtitle: const Text('Allow BIT students to request referrals for this position'),
                value: _acceptsReferrals,
                onChanged: (v) => setState(() => _acceptsReferrals = v),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Publish Job Listing',
                isLoading: _isSubmitting,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
