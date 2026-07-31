/// Admin Dashboard Analytics Statistics Data Model
class AdminStatsModel {
  final int totalStudents;
  final int totalAlumni;
  final int pendingVerifications;
  final int totalEvents;
  final double totalDonationsRaised;
  final int activeMentorships;
  final int activeJobPostings;

  const AdminStatsModel({
    required this.totalStudents,
    required this.totalAlumni,
    required this.pendingVerifications,
    required this.totalEvents,
    required this.totalDonationsRaised,
    required this.activeMentorships,
    required this.activeJobPostings,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalStudents: json['total_students'] as int? ?? 0,
      totalAlumni: json['total_alumni'] as int? ?? 0,
      pendingVerifications: json['pending_verifications'] as int? ?? 0,
      totalEvents: json['total_events'] as int? ?? 0,
      totalDonationsRaised: (json['total_donations'] as num?)?.toDouble() ?? 0.0,
      activeMentorships: json['active_mentorships'] as int? ?? 0,
      activeJobPostings: json['active_jobs'] as int? ?? 0,
    );
  }
}
