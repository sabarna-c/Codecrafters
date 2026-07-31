import '../core/services/supabase_admin_service.dart';
import '../models/admin_stats_model.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';

abstract class IAdminRepository {
  Future<AdminStatsModel> getStats();
  Future<List<ProfileModel>> getUnverifiedAlumni();
  Future<bool> verifyAlumni(String profileId);
  Future<List<UserModel>> getUsers();
  Future<bool> changeUserRole(String userId, String newRole);
  Future<bool> sendBroadcastNotification(String title, String body, String targetRole);
}

class AdminRepository implements IAdminRepository {
  final SupabaseAdminService _service;

  AdminRepository(this._service);

  @override
  Future<AdminStatsModel> getStats() async {
    return await _service.fetchStats();
  }

  @override
  Future<List<ProfileModel>> getUnverifiedAlumni() async {
    return await _service.fetchUnverifiedAlumni();
  }

  @override
  Future<bool> verifyAlumni(String profileId) async {
    return await _service.verifyAlumni(profileId);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    return await _service.fetchAllUsers();
  }

  @override
  Future<bool> changeUserRole(String userId, String newRole) async {
    return await _service.updateUserRole(userId, newRole);
  }

  @override
  Future<bool> sendBroadcastNotification(String title, String body, String targetRole) async {
    return await _service.broadcastNotification(title, body, targetRole);
  }
}
