import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/profile_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../providers/directory_provider.dart';
import '../../widgets/common/skill_chip.dart';
import '../../widgets/common/custom_button.dart';

class AlumniProfileDetailScreen extends ConsumerWidget {
  final ProfileModel alumni;

  const AlumniProfileDetailScreen({
    super.key,
    required this.alumni,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(directoryRepositoryProvider);
    final isFollowing = repo.isFollowing(alumni.userId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(alumni.fullName, style: const TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white24,
                    child: Text(
                      alumni.fullName.isNotEmpty ? alumni.fullName[0] : 'A',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    alumni.fullName,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (alumni.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified_rounded, color: AppColors.secondaryEmerald, size: 20),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alumni.headline ?? '${alumni.jobTitle} at ${alumni.company}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryBlueLight),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alumni.email ?? 'No email available',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailTile('${alumni.departmentName ?? 'BIT College'} • Batch of ${alumni.batchYear ?? 2020}'),
                  _buildDetailTile('${alumni.company ?? 'N/A'} (${alumni.jobTitle ?? 'Alumni'})'),
                  if (alumni.location != null) _buildDetailTile(alumni.location!),
                  const SizedBox(height: 24),
                  Text('About', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    alumni.bio ?? 'No bio provided.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Text('Skills & Expertise', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: alumni.skills.map((s) => SkillChip(label: s)).toList(),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: isFollowing ? 'Following' : 'Follow Alumni',
                    isSecondary: isFollowing,
                    onPressed: () async {
                      final nowFollowing = await ref.read(alumniDirectoryProvider.notifier).toggleFollow(alumni.userId);
                      if (context.mounted) {
                        SnackbarUtils.showSuccess(
                          context,
                          nowFollowing ? 'Following ${alumni.fullName}' : 'Unfollowed ${alumni.fullName}',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Request Mentorship Session',
                    onPressed: () {
                      SnackbarUtils.showSuccess(context, 'Mentorship request sent to ${alumni.fullName}');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 14)),
    );
  }
}
