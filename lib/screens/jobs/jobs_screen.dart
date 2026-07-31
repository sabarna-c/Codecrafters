import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/jobs_provider.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../models/job_model.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = ref.watch(filteredJobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BIT Alumni Job Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Post a Job',
            onPressed: () => context.push('/jobs/post'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(jobSearchQueryProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Search jobs, companies, locations...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(jobSearchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(jobsListProvider.future),
              child: filteredJobs.when(
                data: (jobs) => jobs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.work_off_rounded, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No jobs found'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: jobs.length,
                        itemBuilder: (ctx, i) => _JobCard(
                          job: jobs[i],
                          onApply: () async {
                            if (jobs[i].applyLink != null) {
                              final uri = Uri.parse(jobs[i].applyLink!);
                              if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && ctx.mounted) {
                                SnackbarUtils.showSuccess(ctx, 'Opening: ${jobs[i].applyLink}');
                              }
                            }
                          },
                          onReferral: () => _showReferralDialog(context, ref, jobs[i]),
                        ),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReferralDialog(BuildContext context, WidgetRef ref, JobModel job) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Request Referral – ${job.company}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Message to the alumni who posted "${job.title}":'),
            const SizedBox(height: 12),
            TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: 'Hi, I am a BIT CSE 2025 student...')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final repo = ref.read(jobsRepositoryProvider);
              await repo.requestReferral(job.id, 'demo_user', controller.text);
              if (context.mounted) {
                Navigator.pop(context);
                SnackbarUtils.showSuccess(context, 'Referral request sent to ${job.company} alumni!');
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onApply;
  final VoidCallback onReferral;

  const _JobCard({required this.job, required this.onApply, required this.onReferral});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryBlue.withAlpha(20),
                  child: Text(job.company[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text('${job.company} • ${job.location}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _chip(job.jobType, AppColors.primaryBlue),
                _chip(job.experienceLevel, AppColors.secondaryEmerald),
                if (job.salaryRange != null) _chip(job.salaryRange!, AppColors.accentAmber),
              ],
            ),
            if (job.acceptsReferrals) ...[
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.handshake_rounded, size: 16, color: AppColors.secondaryEmerald),
                  SizedBox(width: 6),
                  Text('Referrals accepted from BIT alumni', style: TextStyle(color: AppColors.secondaryEmerald, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReferral,
                    child: const Text('Request Referral'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApply,
                    child: const Text('Apply Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
