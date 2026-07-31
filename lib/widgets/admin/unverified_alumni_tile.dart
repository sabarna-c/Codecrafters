import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../../core/theme/app_colors.dart';

class UnverifiedAlumniTile extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onVerify;

  const UnverifiedAlumniTile({
    super.key,
    required this.profile,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade100,
          child: Text(
            profile.fullName.isNotEmpty ? profile.fullName[0] : 'U',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        ),
        title: Text(
          profile.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${profile.jobTitle ?? 'Alumni'} at ${profile.company ?? 'BIT'}\n${profile.departmentName ?? 'BIT'} • Batch ${profile.batchYear ?? 2022}',
          style: const TextStyle(fontSize: 12),
        ),
        isThreeLine: true,
        trailing: ElevatedButton.icon(
          onPressed: onVerify,
          icon: const Icon(Icons.verified_user_rounded, size: 16),
          label: const Text('Approve'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryEmerald,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }
}
