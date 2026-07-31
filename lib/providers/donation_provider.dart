import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_donation_service.dart';
import '../repositories/donation_repository.dart';
import '../models/donation_model.dart';

final donationServiceProvider = Provider<SupabaseDonationService>((ref) {
  return SupabaseDonationService(Supabase.instance.client);
});

final donationRepositoryProvider = Provider<IDonationRepository>((ref) {
  return DonationRepository(ref.watch(donationServiceProvider));
});

final donationCausesProvider = FutureProvider<List<DonationCauseModel>>((ref) async {
  return await ref.watch(donationRepositoryProvider).getCauses();
});

final utilizationReportsProvider = FutureProvider.family<List<UtilizationReportModel>, String>((ref, causeId) async {
  return await ref.watch(donationRepositoryProvider).getReports(causeId);
});

class DonationCheckoutState {
  final bool isProcessing;
  final bool isSuccess;
  final String? errorMessage;
  const DonationCheckoutState({this.isProcessing = false, this.isSuccess = false, this.errorMessage});
  DonationCheckoutState copyWith({bool? isProcessing, bool? isSuccess, String? errorMessage}) {
    return DonationCheckoutState(
      isProcessing: isProcessing ?? this.isProcessing,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class DonationCheckoutNotifier extends StateNotifier<DonationCheckoutState> {
  final IDonationRepository _repository;
  DonationCheckoutNotifier(this._repository) : super(const DonationCheckoutState());

  Future<bool> processDonation({
    required String causeId,
    required String donorId,
    required double amount,
    required bool isAnonymous,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);
    try {
      // Simulate Stripe test payment processing delay
      await Future.delayed(const Duration(seconds: 2));
      final fakeStripeId = 'pi_test_${DateTime.now().millisecondsSinceEpoch}';
      final success = await _repository.donate(
        causeId: causeId,
        donorId: donorId,
        amount: amount,
        stripePaymentId: fakeStripeId,
        isAnonymous: isAnonymous,
      );
      state = state.copyWith(isProcessing: false, isSuccess: success);
      return success;
    } catch (e) {
      state = state.copyWith(isProcessing: false, errorMessage: e.toString());
      return false;
    }
  }
}

final donationCheckoutProvider = StateNotifierProvider.autoDispose<DonationCheckoutNotifier, DonationCheckoutState>((ref) {
  return DonationCheckoutNotifier(ref.watch(donationRepositoryProvider));
});
