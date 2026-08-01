/// User Profile model mapping user details from Supabase profiles table
class ProfileModel {
  final String id;
  final String userId;
  final String fullName;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final String? headline;
  final String? departmentId;
  final String? departmentName;
  final String? batchId;
  final int? batchYear;
  final String? company;
  final String? jobTitle;
  final String? location;
  final String? linkedinUrl;
  final String? phone;
  final List<String> skills;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.id,
    required this.userId,
    required this.fullName,
    this.email,
    this.avatarUrl,
    this.bio,
    this.headline,
    this.departmentId,
    this.departmentName,
    this.batchId,
    this.batchYear,
    this.company,
    this.jobTitle,
    this.location,
    this.linkedinUrl,
    this.phone,
    this.skills = const [],
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String? ?? 'BIT Member',
      email: json['users'] != null ? json['users']['email'] as String? : null,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      headline: json['headline'] as String?,
      departmentId: json['department_id'] as String?,
      departmentName: json['departments'] != null ? json['departments']['name'] as String? : null,
      batchId: json['batch_id'] as String?,
      batchYear: json['batches'] != null ? json['batches']['year'] as int? : null,
      company: json['company'] as String?,
      jobTitle: json['job_title'] as String?,
      location: json['location'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      phone: json['phone'] as String?,
      skills: json['skills'] != null ? List<String>.from(json['skills'] as List) : [],
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'headline': headline,
      'department_id': departmentId,
      'batch_id': batchId,
      'company': company,
      'job_title': jobTitle,
      'location': location,
      'linkedin_url': linkedinUrl,
      'phone': phone,
      'skills': skills,
      'is_verified': isVerified,
    };
  }
}
