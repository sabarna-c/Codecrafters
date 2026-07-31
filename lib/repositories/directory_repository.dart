import '../core/services/supabase_directory_service.dart';
import '../models/profile_model.dart';
import '../models/department_model.dart';
import '../models/batch_model.dart';
import '../models/alumni_filter_model.dart';

abstract class IDirectoryRepository {
  Future<List<ProfileModel>> getAlumni({required AlumniFilterModel filter, int page = 0});
  Future<List<DepartmentModel>> getDepartments();
  Future<List<BatchModel>> getBatches();
  Future<bool> toggleFollowAlumni(String alumniUserId);
}

class DirectoryRepository implements IDirectoryRepository {
  final SupabaseDirectoryService _service;
  final Set<String> _followedAlumniIds = {};

  DirectoryRepository(this._service);

  @override
  Future<List<ProfileModel>> getAlumni({required AlumniFilterModel filter, int page = 0}) async {
    return await _service.fetchAlumni(filter: filter, page: page);
  }

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    return await _service.fetchDepartments();
  }

  @override
  Future<List<BatchModel>> getBatches() async {
    return await _service.fetchBatches();
  }

  @override
  Future<bool> toggleFollowAlumni(String alumniUserId) async {
    if (_followedAlumniIds.contains(alumniUserId)) {
      _followedAlumniIds.remove(alumniUserId);
      return false; // Unfollowed
    } else {
      _followedAlumniIds.add(alumniUserId);
      return true; // Followed
    }
  }

  bool isFollowing(String alumniUserId) => _followedAlumniIds.contains(alumniUserId);
}
