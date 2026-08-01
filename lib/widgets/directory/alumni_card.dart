import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/profile_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../providers/directory_provider.dart';
import '../common/skill_chip.dart';

/// Professional Alumni Card Widget
class AlumniCard extends ConsumerWidget {
  final ProfileModel alumni;
  final VoidCallback onTap;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(directoryRepositoryProvider);
    final isFollowing = repo.isFollowing(alumni.userId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryBlue.withAlpha(30),
                    child: Text(
                      alumni.fullName.isNotEmpty ? alumni.fullName[0] : 'A',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                alumni.fullName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (alumni.isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                color: AppColors.secondaryEmerald,
                                size: 18,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          alumni.headline ?? '${alumni.jobTitle ?? 'Alumni'} at ${alumni.company ?? 'BIT College'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alumni.email ?? 'No email on file',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${alumni.departmentName ?? 'BIT'} • Batch of ${alumni.batchYear ?? 2020}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (alumni.skills.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: alumni.skills.take(3).map((s) => SkillChip(label: s)).toList(),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final nowFollowing = await ref.read(alumniDirectoryProvider.notifier).toggleFollow(alumni.userId);
                        if (context.mounted) {
                          SnackbarUtils.showSuccess(
                            context,
                            nowFollowing ? 'Following ${alumni.fullName}' : 'Unfollowed ${alumni.fullName}',
                          );
                        }
                      },
                      child: Text(isFollowing ? 'Following' : 'Follow'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SnackbarUtils.showSuccess(context, 'Opening chat with ${alumni.fullName}...');
                      },
                      child: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
