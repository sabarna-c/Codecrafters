import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/donation_provider.dart';
import '../../widgets/donation/donation_cause_card.dart';

class DonationScreen extends ConsumerWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final causesAsync = ref.watch(donationCausesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('BIT Alumni Giving')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(donationCausesProvider.future),
        child: causesAsync.when(
          data: (causes) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: causes.length,
            itemBuilder: (ctx, i) => DonationCauseCard(
              cause: causes[i],
              onDonate: () => context.push('/donation/checkout/${causes[i].id}', extra: causes[i]),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading causes: $e')),
        ),
      ),
    );
  }
}
