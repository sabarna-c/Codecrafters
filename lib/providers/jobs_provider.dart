import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_jobs_service.dart';
import '../repositories/jobs_repository.dart';
import '../models/job_model.dart';

final jobsServiceProvider = Provider<SupabaseJobsService>((ref) {
  return SupabaseJobsService(Supabase.instance.client);
});

final jobsRepositoryProvider = Provider<IJobsRepository>((ref) {
  return JobsRepository(ref.watch(jobsServiceProvider));
});

final jobsListProvider = FutureProvider<List<JobModel>>((ref) async {
  return await ref.watch(jobsRepositoryProvider).getJobs();
});

final jobSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredJobsProvider = Provider<AsyncValue<List<JobModel>>>((ref) {
  final jobsAsync = ref.watch(jobsListProvider);
  final query = ref.watch(jobSearchQueryProvider).toLowerCase();

  return jobsAsync.whenData((jobs) {
    if (query.isEmpty) return jobs;
    return jobs.where((j) {
      return j.title.toLowerCase().contains(query) ||
          j.company.toLowerCase().contains(query) ||
          j.location.toLowerCase().contains(query);
    }).toList();
  });
});
