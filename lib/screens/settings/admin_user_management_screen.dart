import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/snackbar_utils.dart';

class AdminUserManagementScreen extends ConsumerWidget {
  const AdminUserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userManagementProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User & Role Management')),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(user.email[0].toUpperCase()),
                ),
                title: Text(user.email, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Role: ${user.role.toUpperCase()}'),
                trailing: PopupMenuButton<String>(
                  initialValue: user.role,
                  onSelected: (newRole) async {
                    final res = await ref.read(userManagementProvider.notifier).updateRole(user.id, newRole);
                    if (context.mounted && res) {
                      SnackbarUtils.showSuccess(context, 'User role updated to ${newRole.toUpperCase()}');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: AppConstants.roleStudent, child: Text('Student')),
                    const PopupMenuItem(value: AppConstants.roleAlumni, child: Text('Alumni')),
                    const PopupMenuItem(value: AppConstants.roleAdmin, child: Text('Admin')),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading users: $e')),
      ),
    );
  }
}
