import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/admin/stat_card.dart';
import '../../widgets/admin/analytics_chart.dart';
import '../../widgets/admin/unverified_alumni_tile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/snackbar_utils.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);
    final unverifiedAsync = ref.watch(unverifiedAlumniProvider);
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BIT Admin Control Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_rounded),
            tooltip: 'User Management',
            onPressed: () => context.push('/admin/users'),
          ),
          IconButton(
            icon: const Icon(Icons.campaign_rounded),
            tooltip: 'Broadcast Notification',
            onPressed: () => context.push('/admin/broadcast'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview Analytics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            statsAsync.when(
              data: (stats) => GridView.count(
                crossAxisCount: isWeb ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(title: 'Students Registered', value: '${stats.totalStudents}', icon: Icons.school_rounded, color: AppColors.studentBadge),
                  StatCard(title: 'Alumni Network', value: '${stats.totalAlumni}', icon: Icons.workspace_premium_rounded, color: AppColors.alumniBadge),
                  StatCard(title: 'Pending Verifications', value: '${stats.pendingVerifications}', icon: Icons.pending_actions_rounded, color: AppColors.accentAmber),
                  StatCard(title: 'Donations Raised', value: '\$${stats.totalDonationsRaised.toInt()}', icon: Icons.volunteer_activism_rounded, color: AppColors.secondaryEmerald),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error loading stats: $e'),
            ),
            const SizedBox(height: 24),
            const AnalyticsChart(),
            const SizedBox(height: 28),
            Text('Pending Alumni Verification Requests', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            unverifiedAsync.when(
              data: (list) => list.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded, color: AppColors.secondaryEmerald),
                            SizedBox(width: 12),
                            Text('All alumni verification requests have been processed.'),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: list.map((profile) {
                        return UnverifiedAlumniTile(
                          profile: profile,
                          onVerify: () async {
                            final success = await ref.read(unverifiedAlumniProvider.notifier).verify(profile.id);
                            if (context.mounted && success) {
                              SnackbarUtils.showSuccess(context, 'Alumni verified: ${profile.fullName}');
                            }
                          },
                        );
                      }).toList(),
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error loading unverified list: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
