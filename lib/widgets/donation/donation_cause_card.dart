import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/donation_model.dart';
import '../../core/theme/app_colors.dart';

class DonationCauseCard extends StatelessWidget {
  final DonationCauseModel cause;
  final VoidCallback onDonate;

  const DonationCauseCard({super.key, required this.cause, required this.onDonate});

  @override
  Widget build(BuildContext context) {
    final progressPct = cause.progressPercent;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header
          Container(
            height: 80,
            decoration: const BoxDecoration(gradient: AppColors.emeraldGradient),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 32),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${cause.raisedAmount.toStringAsFixed(0)} raised',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('of \$${cause.targetAmount.toStringAsFixed(0)} goal',
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cause.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(cause.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPct,
                    minHeight: 10,
                    backgroundColor: Colors.grey.withAlpha(40),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryEmerald),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${(progressPct * 100).toStringAsFixed(1)}% funded',
                        style: const TextStyle(color: AppColors.secondaryEmerald, fontWeight: FontWeight.w600, fontSize: 12)),
                    Text('\$${cause.remainingAmount.toStringAsFixed(0)} remaining', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/donation/reports/${cause.id}'),
                        icon: const Icon(Icons.receipt_long_rounded, size: 16),
                        label: const Text('View Reports'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDonate,
                        icon: const Icon(Icons.favorite_rounded, size: 16),
                        label: const Text('Donate'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
