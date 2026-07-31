/// Mentor Request Model representing student-mentor booking sessions
class MentorRequestModel {
  final String id;
  final String mentorId;
  final String studentId;
  final String studentName;
  final String mentorName;
  final String message;
  final String status; // pending, accepted, rejected, completed
  final String? meetingUrl;
  final DateTime createdAt;

  const MentorRequestModel({
    required this.id,
    required this.mentorId,
    required this.studentId,
    required this.studentName,
    required this.mentorName,
    required this.message,
    this.status = 'pending',
    this.meetingUrl,
    required this.createdAt,
  });

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status == 'completed';

  factory MentorRequestModel.fromJson(Map<String, dynamic> json) {
    return MentorRequestModel(
      id: json['id'] as String,
      mentorId: json['mentor_id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String? ?? 'Student',
      mentorName: json['mentor_name'] as String? ?? 'Alumni Mentor',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      meetingUrl: json['meeting_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentor_id': mentorId,
      'student_id': studentId,
      'message': message,
      'status': status,
      'meeting_url': meetingUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
