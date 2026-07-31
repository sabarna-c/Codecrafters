import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_router.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () => context.push(AppRoutes.directory),
          ),
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
            // Welcome Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.school_rounded, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome Back, Student!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('BIT Department of Computer Science', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.stars_rounded, color: AppColors.accentAmber, size: 18),
                        SizedBox(width: 8),
                        Text('Mentorship Program 2026 Active', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Quick Launch', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                _HubCard(
                  title: 'Alumni Directory',
                  subtitle: 'Search 500+ BIT Alumni',
                  icon: Icons.people_alt_rounded,
                  color: AppColors.primaryBlue,
                  onTap: () => context.push(AppRoutes.directory),
                ),
                _HubCard(
                  title: 'Mentorship',
                  subtitle: 'Book 1-on-1 Guidance',
                  icon: Icons.psychology_rounded,
                  color: AppColors.secondaryEmerald,
                  onTap: () => context.push(AppRoutes.mentorship),
                ),
                _HubCard(
                  title: 'Events & Meetups',
                  subtitle: 'QR Attendance Passes',
                  icon: Icons.event_available_rounded,
                  color: AppColors.accentAmber,
                  onTap: () => context.push(AppRoutes.events),
                ),
                _HubCard(
                  title: 'Job Portal',
                  subtitle: 'Alumni Referrals & Roles',
                  icon: Icons.work_outline_rounded,
                  color: Colors.deepPurple,
                  onTap: () => context.push(AppRoutes.jobs),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Giving Campaign Callout
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.tealAccent,
                  child: Icon(Icons.volunteer_activism_rounded, color: Colors.teal),
                ),
                title: const Text('BIT Innovation Fund 2026', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Support scholarships & AI lab equipment'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () => context.push(AppRoutes.donation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HubCard({
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
