import 'package:flutter/material.dart';
import '../../models/mentor_model.dart';
import '../../core/theme/app_colors.dart';
import '../common/skill_chip.dart';

/// Mentor Presentation Card
class MentorCard extends StatelessWidget {
  final MentorModel mentor;
  final VoidCallback onBookTap;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.secondaryEmerald.withAlpha(30),
                  child: Text(
                    mentor.fullName.isNotEmpty ? mentor.fullName[0] : 'M',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.secondaryEmerald),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              mentor.fullName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryEmerald.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              mentor.status.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryEmerald),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${mentor.jobTitle} at ${mentor.company}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (mentor.bio != null) ...[
              const SizedBox(height: 12),
              Text(mentor.bio!, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: mentor.expertise.map((e) => SkillChip(label: e)).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      mentor.hourlyAvailability ?? 'Flexible Hours',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onBookTap,
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: const Text('Book 1-on-1'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
