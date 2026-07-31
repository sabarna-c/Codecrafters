import '../core/services/supabase_jobs_service.dart';
import '../models/job_model.dart';

abstract class IJobsRepository {
  Future<List<JobModel>> getJobs();
  Future<bool> postJob(JobModel job, String postedById);
  Future<bool> requestReferral(String jobId, String userId, String message);
}

class JobsRepository implements IJobsRepository {
  final SupabaseJobsService _service;
  JobsRepository(this._service);

  @override
  Future<List<JobModel>> getJobs() async => await _service.fetchJobs();

  @override
  Future<bool> postJob(JobModel job, String postedById) async {
    final data = job.toJson()..['posted_by_id'] = postedById;
    return await _service.postJob(data);
  }

  @override
  Future<bool> requestReferral(String jobId, String userId, String message) async {
    return await _service.requestReferral(jobId, userId, message);
  }
}
