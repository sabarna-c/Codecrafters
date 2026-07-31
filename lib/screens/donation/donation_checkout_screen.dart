import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../widgets/common/custom_button.dart';

class DonationCheckoutScreen extends ConsumerStatefulWidget {
  final DonationCauseModel cause;
  const DonationCheckoutScreen({super.key, required this.cause});

  @override
  ConsumerState<DonationCheckoutScreen> createState() => _DonationCheckoutScreenState();
}

class _DonationCheckoutScreenState extends ConsumerState<DonationCheckoutScreen> {
  double _selectedAmount = 50.0;
  bool _isAnonymous = false;
  final _customController = TextEditingController();
  bool _useCustom = false;

  final List<double> _presets = [10, 25, 50, 100, 250, 500];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Future<void> _handleDonate() async {
    final amount = _useCustom ? (double.tryParse(_customController.text) ?? 0) : _selectedAmount;
    if (amount <= 0) {
      SnackbarUtils.showError(context, 'Please enter a valid donation amount.');
      return;
    }
    final userId = ref.read(authControllerProvider).user?.id ?? 'demo_donor';
    final notifier = ref.read(donationCheckoutProvider.notifier);
    final success = await notifier.processDonation(
      causeId: widget.cause.id,
      donorId: userId,
      amount: amount,
      isAnonymous: _isAnonymous,
    );
    if (!mounted) return;
    if (success) {
      _showSuccessDialog(amount);
    } else {
      SnackbarUtils.showError(context, 'Payment failed. Please try again.');
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 72, color: AppColors.secondaryEmerald),
            const SizedBox(height: 16),
            Text('Thank You!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)} donated to\n"${widget.cause.title}"',
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            const Text('Your contribution will be reflected in the Utilization Report.',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Done')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(donationCheckoutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Donation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.emeraldGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.cause.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('\$${widget.cause.raisedAmount.toStringAsFixed(0)} raised of \$${widget.cause.targetAmount.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Select Amount', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _presets.map((amt) {
                final isSelected = !_useCustom && _selectedAmount == amt;
                return ChoiceChip(
                  label: Text('\$${amt.toInt()}'),
                  selected: isSelected,
                  onSelected: (_) => setState(() { _selectedAmount = amt; _useCustom = false; }),
                  selectedColor: AppColors.secondaryEmerald,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : null, fontWeight: FontWeight.bold),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              onTap: () => setState(() => _useCustom = true),
              decoration: InputDecoration(
                hintText: 'Enter custom amount (\$)',
                prefixIcon: const Icon(Icons.attach_money_rounded),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.secondaryEmerald, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Donate Anonymously'),
              subtitle: const Text('Your name will not appear in public reports'),
              value: _isAnonymous,
              onChanged: (v) => setState(() => _isAnonymous = v),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_rounded, size: 18, color: AppColors.primaryBlue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Payments secured by Stripe Test Mode. No real card is charged.',
                      style: TextStyle(fontSize: 12, color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            CustomButton(
              text: 'Confirm & Pay with Stripe',
              isLoading: checkoutState.isProcessing,
              onPressed: _handleDonate,
            ),
          ],
        ),
      ),
    );
  }
}
