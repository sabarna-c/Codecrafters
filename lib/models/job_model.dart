/// Job Model representing job listings posted by alumni
class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String experienceLevel;
  final String description;
  final String? salaryRange;
  final String? postedById;
  final String? applyLink;
  final bool acceptsReferrals;
  final DateTime createdAt;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    this.jobType = 'Full-Time',
    this.experienceLevel = 'Entry Level',
    required this.description,
    this.salaryRange,
    this.postedById,
    this.applyLink,
    this.acceptsReferrals = true,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      jobType: json['job_type'] as String? ?? 'Full-Time',
      experienceLevel: json['experience_level'] as String? ?? 'Entry Level',
      description: json['description'] as String,
      salaryRange: json['salary_range'] as String?,
      postedById: json['posted_by_id'] as String?,
      applyLink: json['apply_link'] as String?,
      acceptsReferrals: json['accepts_referrals'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'company': company,
        'location': location,
        'job_type': jobType,
        'experience_level': experienceLevel,
        'description': description,
        'salary_range': salaryRange,
        'apply_link': applyLink,
        'accepts_referrals': acceptsReferrals,
      };
}
