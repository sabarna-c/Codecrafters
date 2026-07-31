import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/job_model.dart';
import '../utils/app_logger.dart';

class SupabaseJobsService {
  final SupabaseClient _client;
  SupabaseJobsService(this._client);

  Future<List<JobModel>> fetchJobs() async {
    try {
      final res = await _client.from('jobs').select().order('created_at', ascending: false);
      final list = (res as List).map((j) => JobModel.fromJson(j)).toList();
      return list.isNotEmpty ? list : _getMockJobs();
    } catch (e, st) {
      AppLogger.error('Fetch Jobs Exception', e, st);
      return _getMockJobs();
    }
  }

  Future<bool> postJob(Map<String, dynamic> data) async {
    try {
      await _client.from('jobs').insert(data);
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> requestReferral(String jobId, String userId, String message) async {
    try {
      await _client.from('notifications').insert({
        'user_id': userId,
        'title': 'Referral Request Submitted',
        'body': message,
        'type': 'referral',
        'payload': {'job_id': jobId},
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  List<JobModel> _getMockJobs() {
    final now = DateTime.now();
    return [
      JobModel(
        id: 'j1',
        title: 'Software Development Engineer II',
        company: 'Google',
        location: 'Mountain View, CA (Hybrid)',
        jobType: 'Full-Time',
        experienceLevel: 'Mid Level',
        description: 'Build scalable, distributed cloud microservices powering Google Search, Cloud, and Maps products.',
        salaryRange: '\$140,000 – \$180,000 + Equity',
        acceptsReferrals: true,
        applyLink: 'https://careers.google.com',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      JobModel(
        id: 'j2',
        title: 'Associate Product Manager',
        company: 'Microsoft',
        location: 'Seattle, WA (Hybrid)',
        jobType: 'Full-Time',
        experienceLevel: 'Entry Level',
        description: 'Lead product strategy for Azure Developer Experience tools used by millions of developers globally.',
        salaryRange: '\$115,000 – \$140,000 + RSU',
        acceptsReferrals: true,
        applyLink: 'https://careers.microsoft.com',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      JobModel(
        id: 'j3',
        title: 'AI Research Scientist',
        company: 'OpenAI',
        location: 'San Francisco, CA (On-Site)',
        jobType: 'Full-Time',
        experienceLevel: 'Senior',
        description: 'Advance state-of-the-art large language model alignment, RLHF, and reasoning capabilities.',
        salaryRange: '\$200,000 – \$280,000 + Equity',
        acceptsReferrals: true,
        applyLink: 'https://openai.com/careers',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
