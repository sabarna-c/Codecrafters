import '../core/services/supabase_auth_service.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';
import '../core/utils/app_logger.dart';

abstract class IAuthRepository {
  Future<UserModel?> login({required String email, required String password});
  Future<UserModel?> register({
    required String email,
    required String password,
    required String role,
    required String fullName,
  });
  Future<void> sendPasswordReset(String email);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<ProfileModel?> getCurrentProfile();
}

class AuthRepository implements IAuthRepository {
  final SupabaseAuthService _authService;

  AuthRepository(this._authService);

  @override
  Future<UserModel?> login({required String email, required String password}) async {
    try {
      final authRes = await _authService.signInWithPassword(email: email, password: password);
      if (authRes.user != null) {
        final userData = await _authService.fetchUserData(authRes.user!.id);
        return userData ?? UserModel(
          id: authRes.user!.id,
          email: authRes.user!.email ?? email,
          role: authRes.user!.userMetadata?['role'] ?? 'student',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      AppLogger.error('AuthRepository Login Error: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> register({
    required String email,
    required String password,
    required String role,
    required String fullName,
  }) async {
    try {
      final authRes = await _authService.signUp(
        email: email,
        password: password,
        role: role,
        fullName: fullName,
      );
      if (authRes.user != null) {
        return UserModel(
          id: authRes.user!.id,
          email: email,
          role: role,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      AppLogger.error('AuthRepository Register Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _authService.currentUser;
    if (user == null) return null;
    return await _authService.fetchUserData(user.id);
  }

  @override
  Future<ProfileModel?> getCurrentProfile() async {
    final user = _authService.currentUser;
    if (user == null) return null;
    return await _authService.fetchProfile(user.id);
  }
}
