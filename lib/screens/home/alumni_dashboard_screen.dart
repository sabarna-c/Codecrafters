import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';

class AlumniDashboardScreen extends ConsumerWidget {
  const AlumniDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final profileName = authState.profile?.fullName ?? 'Alumni';
    final email = authState.user?.email ?? 'alumni@bitcollege.edu';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumni Portal'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _ProfileCorner(
              name: profileName,
              email: email,
              onTap: () => context.push(AppRoutes.directory),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verified Alumni',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Senior SDE • Google | BIT CSE 2020',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Alumni Management', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.18,
              children: [
                _ActionCard(title: 'Mentorship Requests', subtitle: 'Review sessions', onTap: () => context.push(AppRoutes.mentorRequests)),
                _ActionCard(title: 'Alumni Directory', subtitle: 'Network with peers', onTap: () => context.push(AppRoutes.directory)),
                _ActionCard(title: 'Giving & Funds', subtitle: 'Donate & reports', onTap: () => context.push(AppRoutes.donation)),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text('Global BIT Alumni Meet 2026', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Get your entry QR pass'),
                trailing: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.events),
                  child: const Text('Get Pass'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people_alt_outlined), label: 'Directory'),
          NavigationDestination(icon: Icon(Icons.psychology_outlined), label: 'Mentor'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.volunteer_activism_outlined), label: 'Donate'),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.push(AppRoutes.directory);
              break;
            case 1:
              context.push(AppRoutes.mentorRequests);
              break;
            case 2:
              context.push(AppRoutes.events);
              break;
            case 3:
              context.push(AppRoutes.donation);
              break;
          }
        },
      ),
    );
  }
}

class _ProfileCorner extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onTap;

  const _ProfileCorner({
    required this.name,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join().toUpperCase();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 14, child: Text(initials)),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(email, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
