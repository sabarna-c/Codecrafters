/// Donation Cause Model for fundraising campaigns
class DonationCauseModel {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double raisedAmount;
  final String? bannerUrl;
  final String status;

  const DonationCauseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.raisedAmount,
    this.bannerUrl,
    this.status = 'active',
  });

  double get progressPercent => targetAmount > 0 ? (raisedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get remainingAmount => (targetAmount - raisedAmount).clamp(0.0, targetAmount);

  factory DonationCauseModel.fromJson(Map<String, dynamic> json) {
    return DonationCauseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      raisedAmount: (json['raised_amount'] as num?)?.toDouble() ?? 0.0,
      bannerUrl: json['banner_url'] as String?,
      status: json['status'] as String? ?? 'active',
    );
  }
}

/// Utilization Report Model for transparent fund reporting
class UtilizationReportModel {
  final String id;
  final String causeId;
  final String title;
  final String description;
  final double amountSpent;
  final String? proofDocumentUrl;
  final DateTime reportDate;

  const UtilizationReportModel({
    required this.id,
    required this.causeId,
    required this.title,
    required this.description,
    required this.amountSpent,
    this.proofDocumentUrl,
    required this.reportDate,
  });

  factory UtilizationReportModel.fromJson(Map<String, dynamic> json) {
    return UtilizationReportModel(
      id: json['id'] as String,
      causeId: json['cause_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amountSpent: (json['amount_spent'] as num?)?.toDouble() ?? 0.0,
      proofDocumentUrl: json['proof_document_url'] as String?,
      reportDate: json['report_date'] != null
          ? DateTime.parse(json['report_date'] as String)
          : DateTime.now(),
    );
  }
}
