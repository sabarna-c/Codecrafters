/// Mentor Model representing alumni registered as mentors
class MentorModel {
  final String id;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String company;
  final String jobTitle;
  final List<String> expertise;
  final int maxMentees;
  final String status; // available, busy, inactive
  final String? hourlyAvailability;
  final String? bio;

  const MentorModel({
    required this.id,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    required this.company,
    required this.jobTitle,
    required this.expertise,
    this.maxMentees = 5,
    this.status = 'available',
    this.hourlyAvailability,
    this.bio,
  });

  bool get isAvailable => status == 'available';

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return MentorModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: profile != null ? (profile['full_name'] as String? ?? 'BIT Mentor') : (json['full_name'] as String? ?? 'BIT Mentor'),
      avatarUrl: profile != null ? profile['avatar_url'] as String? : json['avatar_url'] as String?,
      company: profile != null ? (profile['company'] as String? ?? 'Tech Inc') : (json['company'] as String? ?? 'Tech Inc'),
      jobTitle: profile != null ? (profile['job_title'] as String? ?? 'Senior Engineer') : (json['job_title'] as String? ?? 'Senior Engineer'),
      expertise: json['expertise'] != null ? List<String>.from(json['expertise'] as List) : [],
      maxMentees: json['max_mentees'] as int? ?? 5,
      status: json['status'] as String? ?? 'available',
      hourlyAvailability: json['hourly_availability'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'expertise': expertise,
      'max_mentees': maxMentees,
      'status': status,
      'hourly_availability': hourlyAvailability,
      'bio': bio,
    };
  }
}
