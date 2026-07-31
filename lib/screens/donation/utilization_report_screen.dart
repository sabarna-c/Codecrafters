import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/donation_provider.dart';
import '../../core/theme/app_colors.dart';

class UtilizationReportScreen extends ConsumerWidget {
  final String causeId;
  final String causeTitle;

  const UtilizationReportScreen({super.key, required this.causeId, required this.causeTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(utilizationReportsProvider(causeId));

    return Scaffold(
      appBar: AppBar(title: Text('Utilization Reports: $causeTitle', overflow: TextOverflow.ellipsis)),
      body: reportsAsync.when(
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No utilization reports yet.'),
                  SizedBox(height: 8),
                  Text('Reports will appear as funds are utilized.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          final totalSpent = reports.fold<double>(0, (s, r) => s + r.amountSpent);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Funds Utilized', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text('\$${totalSpent.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_rounded, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Expenditure Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ...reports.map((r) {
                final fmt = DateFormat('MMM dd, yyyy').format(r.reportDate);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(r.title,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryEmerald.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('\$${r.amountSpent.toStringAsFixed(2)}',
                                  style: const TextStyle(color: AppColors.secondaryEmerald, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r.description, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 13, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(fmt, style: Theme.of(context).textTheme.labelSmall),
                            if (r.proofDocumentUrl != null) ...[
                              const SizedBox(width: 12),
                              const Icon(Icons.attach_file_rounded, size: 13, color: AppColors.primaryBlue),
                              const SizedBox(width: 4),
                              const Text('Proof attached', style: TextStyle(color: AppColors.primaryBlue, fontSize: 11)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
