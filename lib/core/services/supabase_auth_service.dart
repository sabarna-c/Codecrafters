import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';
import '../../models/profile_model.dart';
import '../utils/app_logger.dart';

/// Low-level Supabase Authentication service wrapper
class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService(this._client);

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Register new user with Supabase Auth
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String role,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'role': role,
          'full_name': fullName,
        },
      );
      return response;
    } catch (e, st) {
      AppLogger.error('SignUp Exception', e, st);
      rethrow;
    }
  }

  /// Sign in with Email & Password
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      AppLogger.warn('AuthException encountered: ${e.message}');
      rethrow;
    } catch (e, st) {
      AppLogger.error('SignIn Exception: $e', e, st);
      rethrow;
    }
  }

  /// Trigger Forgot Password Reset Link
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e, st) {
      AppLogger.error('Password Reset Exception', e, st);
      rethrow;
    }
  }

  /// Fetch User Metadata and Profile
  Future<UserModel?> fetchUserData(String userId) async {
    try {
      final data = await _client.from('users').select().eq('id', userId).maybeSingle();
      if (data != null) {
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e, st) {
      AppLogger.error('Fetch UserData Exception', e, st);
      return null;
    }
  }

  /// Fetch Profile Details
  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final data = await _client.from('profiles').select('*, departments(name), batches(year)').eq('user_id', userId).maybeSingle();
      if (data != null) {
        return ProfileModel.fromJson(data);
      }
      return null;
    } catch (e, st) {
      AppLogger.error('Fetch Profile Exception', e, st);
      return null;
    }
  }

  /// Sign out current session
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e, st) {
      AppLogger.error('SignOut Exception', e, st);
      rethrow;
    }
  }
}
