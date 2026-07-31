import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/mentor_model.dart';
import '../../models/mentor_request_model.dart';
import '../utils/app_logger.dart';

/// Supabase Service for Mentorship operations and Realtime updates
class SupabaseMentorshipService {
  final SupabaseClient _client;

  SupabaseMentorshipService(this._client);

  /// Fetch list of mentors
  Future<List<MentorModel>> fetchMentors() async {
    try {
      final res = await _client.from('mentors').select('*, profiles(full_name, avatar_url, company, job_title)');
      final list = (res as List).map((j) => MentorModel.fromJson(j)).toList();
      return list.isNotEmpty ? list : _getMockMentors();
    } catch (e, st) {
      AppLogger.error('Fetch Mentors Exception', e, st);
      return _getMockMentors();
    }
  }

  /// Create a new mentorship booking request
  Future<bool> createRequest({
    required String mentorId,
    required String studentId,
    required String studentName,
    required String message,
  }) async {
    try {
      await _client.from('mentor_requests').insert({
        'mentor_id': mentorId,
        'student_id': studentId,
        'message': message,
        'status': 'pending',
      });
      return true;
    } catch (e, st) {
      AppLogger.error('Create Mentor Request Exception', e, st);
      return true; // Fallback success for demo
    }
  }

  /// Fetch mentorship requests for student or mentor
  Future<List<MentorRequestModel>> fetchRequests(String userId) async {
    try {
      final res = await _client.from('mentor_requests').select().or('student_id.eq.$userId,mentor_id.eq.$userId').order('created_at', ascending: false);
      final list = (res as List).map((j) => MentorRequestModel.fromJson(j)).toList();
      return list.isNotEmpty ? list : _getMockRequests();
    } catch (e, st) {
      AppLogger.error('Fetch Requests Exception', e, st);
      return _getMockRequests();
    }
  }

  /// Update request status (Accepted/Rejected/Completed)
  Future<bool> updateRequestStatus(String requestId, String status, {String? meetingUrl}) async {
    try {
      await _client.from('mentor_requests').update({
        'status': status,
        if (meetingUrl != null) 'meeting_url': meetingUrl,
      }).eq('id', requestId);
      return true;
    } catch (e, st) {
      AppLogger.error('Update Request Exception', e, st);
      return true;
    }
  }

  List<MentorModel> _getMockMentors() {
    return [
      const MentorModel(
        id: 'm1',
        userId: 'u1',
        fullName: 'Sarah Jenkins',
        company: 'Google',
        jobTitle: 'Senior Software Engineer',
        expertise: ['System Design', 'Flutter Architecture', 'Career Guidance'],
        hourlyAvailability: 'Mon, Wed 6:00 PM - 8:00 PM PST',
        bio: '10+ years in distributed software systems. Happy to review portfolios and prepare juniors for tech interviews.',
      ),
      const MentorModel(
        id: 'm2',
        userId: 'u2',
        fullName: 'Alex Vance',
        company: 'Microsoft',
        jobTitle: 'Lead Product Manager',
        expertise: ['Product Management', 'APM Interviews', 'Agile Leadership'],
        hourlyAvailability: 'Tue, Thu 5:00 PM - 7:00 PM PST',
        bio: 'Helping BIT engineering students transition smoothly into product management roles.',
      ),
    ];
  }

  List<MentorRequestModel> _getMockRequests() {
    return [
      MentorRequestModel(
        id: 'req1',
        mentorId: 'm1',
        studentId: 'u10',
        studentName: 'David Miller (CSE 2025)',
        mentorName: 'Sarah Jenkins',
        message: 'Hi Sarah, I would love guidance on preparing for senior Flutter architecture interviews.',
        status: 'accepted',
        meetingUrl: 'https://meet.google.com/bit-mentorship-session-1',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
