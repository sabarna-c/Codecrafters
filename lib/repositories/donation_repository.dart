import '../core/services/supabase_donation_service.dart';
import '../models/donation_model.dart';

abstract class IDonationRepository {
  Future<List<DonationCauseModel>> getCauses();
  Future<List<UtilizationReportModel>> getReports(String causeId);
  Future<bool> donate({
    required String causeId,
    required String donorId,
    required double amount,
    required String stripePaymentId,
    required bool isAnonymous,
  });
}

class DonationRepository implements IDonationRepository {
  final SupabaseDonationService _service;
  DonationRepository(this._service);

  @override
  Future<List<DonationCauseModel>> getCauses() async => await _service.fetchCauses();

  @override
  Future<List<UtilizationReportModel>> getReports(String causeId) async =>
      await _service.fetchReports(causeId);

  @override
  Future<bool> donate({
    required String causeId,
    required String donorId,
    required double amount,
    required String stripePaymentId,
    required bool isAnonymous,
  }) async {
    return await _service.recordDonation(
      causeId: causeId,
      donorId: donorId,
      amount: amount,
      stripePaymentId: stripePaymentId,
      isAnonymous: isAnonymous,
    );
  }
}
