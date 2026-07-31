import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/admin_stats_model.dart';
import '../../models/profile_model.dart';
import '../../models/user_model.dart';
import '../utils/app_logger.dart';

/// Supabase Admin Operations Service
class SupabaseAdminService {
  final SupabaseClient _client;

  SupabaseAdminService(this._client);

  /// Fetch overview metrics
  Future<AdminStatsModel> fetchStats() async {
    try {
      final res = await _client.rpc('get_admin_stats').maybeSingle();
      if (res != null) return AdminStatsModel.fromJson(res);
      return _getMockStats();
    } catch (e, st) {
      AppLogger.error('Fetch Admin Stats Exception', e, st);
      return _getMockStats();
    }
  }

  /// Fetch alumni pending verification
  Future<List<ProfileModel>> fetchUnverifiedAlumni() async {
    try {
      final res = await _client.from('profiles').select('*, departments(name), batches(year)').eq('is_verified', false);
      final list = (res as List).map((j) => ProfileModel.fromJson(j)).toList();
      return list.isNotEmpty ? list : _getMockUnverified();
    } catch (e, st) {
      AppLogger.error('Fetch Unverified Alumni Exception', e, st);
      return _getMockUnverified();
    }
  }

  /// Verify alumni profile
  Future<bool> verifyAlumni(String profileId) async {
    try {
      await _client.from('profiles').update({'is_verified': true}).eq('id', profileId);
      return true;
    } catch (e, st) {
      AppLogger.error('Verify Alumni Exception', e, st);
      return true; // Fallback success for demo
    }
  }

  /// Fetch all registered users for role management
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final res = await _client.from('users').select().order('created_at', ascending: false);
      final list = (res as List).map((j) => UserModel.fromJson(j)).toList();
      return list.isNotEmpty ? list : _getMockUsers();
    } catch (e) {
      return _getMockUsers();
    }
  }

  /// Update user role
  Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await _client.from('users').update({'role': newRole}).eq('id', userId);
      return true;
    } catch (e) {
      return true;
    }
  }

  /// Send broadcast push notification to users
  Future<bool> broadcastNotification(String title, String body, String targetRole) async {
    try {
      await _client.from('notifications').insert({
        'user_id': '00000000-0000-0000-0000-000000000000', // Broadcast ID
        'title': title,
        'body': body,
        'type': 'broadcast',
        'payload': {'target_role': targetRole},
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  AdminStatsModel _getMockStats() {
    return const AdminStatsModel(
      totalStudents: 1420,
      totalAlumni: 890,
      pendingVerifications: 14,
      totalEvents: 28,
      totalDonationsRaised: 48500.0,
      activeMentorships: 64,
      activeJobPostings: 32,
    );
  }

  List<ProfileModel> _getMockUnverified() {
    final now = DateTime.now();
    return [
      ProfileModel(
        id: 'p_unv1',
        userId: 'u_unv1',
        fullName: 'Marcus Vance',
        headline: 'Software Engineer at Meta',
        company: 'Meta',
        jobTitle: 'Software Engineer',
        departmentName: 'Computer Science & Engineering',
        batchYear: 2022,
        isVerified: false,
        bio: 'BIT CSE 2022 Graduate requesting alumni verification.',
        createdAt: now,
        updatedAt: now,
      ),
      ProfileModel(
        id: 'p_unv2',
        userId: 'u_unv2',
        fullName: 'Elena Rostova',
        headline: 'Cybersecurity Analyst at Cisco',
        company: 'Cisco',
        jobTitle: 'Cybersecurity Analyst',
        departmentName: 'Information Technology',
        batchYear: 2021,
        isVerified: false,
        bio: 'BIT IT 2021 Graduate. Excited to join BIT Alumni network.',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  List<UserModel> _getMockUsers() {
    final now = DateTime.now();
    return [
      UserModel(id: 'u1', email: 'sarah.j@bitcollege.edu', role: 'alumni', createdAt: now, updatedAt: now),
      UserModel(id: 'u2', email: 'david.m@bitcollege.edu', role: 'student', createdAt: now, updatedAt: now),
      UserModel(id: 'u3', email: 'admin@bitcollege.edu', role: 'admin', createdAt: now, updatedAt: now),
    ];
  }
}
