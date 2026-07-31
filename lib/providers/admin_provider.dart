import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_admin_service.dart';
import '../repositories/admin_repository.dart';
import '../models/admin_stats_model.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';

final adminServiceProvider = Provider<SupabaseAdminService>((ref) {
  return SupabaseAdminService(Supabase.instance.client);
});

final adminRepositoryProvider = Provider<IAdminRepository>((ref) {
  final service = ref.watch(adminServiceProvider);
  return AdminRepository(service);
});

final adminStatsProvider = FutureProvider<AdminStatsModel>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return await repo.getStats();
});

class UnverifiedAlumniNotifier extends StateNotifier<AsyncValue<List<ProfileModel>>> {
  final IAdminRepository _repository;

  UnverifiedAlumniNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadUnverified();
  }

  Future<void> loadUnverified() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getUnverifiedAlumni());
  }

  Future<bool> verify(String profileId) async {
    final res = await _repository.verifyAlumni(profileId);
    if (res) {
      await loadUnverified();
    }
    return res;
  }
}

final unverifiedAlumniProvider = StateNotifierProvider.autoDispose<UnverifiedAlumniNotifier, AsyncValue<List<ProfileModel>>>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return UnverifiedAlumniNotifier(repo);
});

class UserManagementNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final IAdminRepository _repository;

  UserManagementNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getUsers());
  }

  Future<bool> updateRole(String userId, String role) async {
    final res = await _repository.changeUserRole(userId, role);
    if (res) {
      await loadUsers();
    }
    return res;
  }
}

final userManagementProvider = StateNotifierProvider.autoDispose<UserManagementNotifier, AsyncValue<List<UserModel>>>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return UserManagementNotifier(repo);
});
