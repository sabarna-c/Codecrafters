import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_auth_service.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';

/// Provider for Supabase Client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for Supabase Auth Service
final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthService(client);
});

/// Provider for Auth Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final service = ref.watch(supabaseAuthServiceProvider);
  return AuthRepository(service);
});

/// Auth State Model
class AuthState {
  final bool isLoading;
  final UserModel? user;
  final ProfileModel? profile;
  final String? errorMessage;
  final String? selectedRole;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.profile,
    this.errorMessage,
    this.selectedRole,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    ProfileModel? profile,
    String? errorMessage,
    String? selectedRole,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}

/// StateNotifier for Auth Operations
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    checkCurrentUser();
  }

  void setSelectedRole(String role) {
    state = state.copyWith(selectedRole: role);
  }

  Future<void> checkCurrentUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getCurrentUser();
      final profile = await _repository.getCurrentProfile();
      state = state.copyWith(isLoading: false, user: user, profile: profile);
    } catch (e) {
      // Ignore background check errors when offline / unconfigured
      state = state.copyWith(isLoading: false, errorMessage: null);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(email: email, password: password);
      final profile = await _repository.getCurrentProfile();
      state = state.copyWith(isLoading: false, user: user, profile: profile);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String role,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        role: role,
        fullName: fullName,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.sendPasswordReset(email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = const AuthState();
  }
}

/// Global Auth Controller Provider
final authControllerProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
