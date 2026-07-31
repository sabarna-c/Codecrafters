import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_router.dart';

class AlumniDashboardScreen extends StatelessWidget {
  const AlumniDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumni Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.go(AppRoutes.login),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verified Alumni Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.emeraldGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 26,
                    child: Icon(Icons.verified_user_rounded, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Verified Alumni', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(width: 6),
                            Icon(Icons.verified_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text('Senior SDE • Google | BIT CSE 2020', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Alumni Management', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                _ActionCard(
                  title: 'Mentorship Requests',
                  subtitle: 'Review & Accept Sessions',
                  icon: Icons.psychology_rounded,
                  color: AppColors.primaryBlue,
                  onTap: () => context.push(AppRoutes.mentorRequests),
                ),
                _ActionCard(
                  title: 'Post a Job',
                  subtitle: 'Hire & Offer Referrals',
                  icon: Icons.add_business_rounded,
                  color: AppColors.secondaryEmerald,
                  onTap: () => context.push(AppRoutes.jobs),
                ),
                _ActionCard(
                  title: 'Alumni Directory',
                  subtitle: 'Network with Peers',
                  icon: Icons.contacts_rounded,
                  color: Colors.purple,
                  onTap: () => context.push(AppRoutes.directory),
                ),
                _ActionCard(
                  title: 'BIT Giving & Funds',
                  subtitle: 'Donate & View Reports',
                  icon: Icons.favorite_rounded,
                  color: Colors.pink,
                  onTap: () => context.push(AppRoutes.donation),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Upcoming Meetup Banner
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  child: Icon(Icons.qr_code_rounded, color: Colors.deepOrange),
                ),
                title: const Text('Global BIT Alumni Meet 2026', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Get your entrance QR pass'),
                trailing: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.events),
                  child: const Text('Get Pass'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
