import '../core/services/supabase_mentorship_service.dart';
import '../models/mentor_model.dart';
import '../models/mentor_request_model.dart';

abstract class IMentorshipRepository {
  Future<List<MentorModel>> getMentors();
  Future<bool> bookSession({
    required String mentorId,
    required String studentId,
    required String studentName,
    required String message,
  });
  Future<List<MentorRequestModel>> getRequests(String userId);
  Future<bool> respondToRequest(String requestId, String status, {String? meetingUrl});
}

class MentorshipRepository implements IMentorshipRepository {
  final SupabaseMentorshipService _service;

  MentorshipRepository(this._service);

  @override
  Future<List<MentorModel>> getMentors() async {
    return await _service.fetchMentors();
  }

  @override
  Future<bool> bookSession({
    required String mentorId,
    required String studentId,
    required String studentName,
    required String message,
  }) async {
    return await _service.createRequest(
      mentorId: mentorId,
      studentId: studentId,
      studentName: studentName,
      message: message,
    );
  }

  @override
  Future<List<MentorRequestModel>> getRequests(String userId) async {
    return await _service.fetchRequests(userId);
  }

  @override
  Future<bool> respondToRequest(String requestId, String status, {String? meetingUrl}) async {
    return await _service.updateRequestStatus(requestId, status, meetingUrl: meetingUrl);
  }
}
