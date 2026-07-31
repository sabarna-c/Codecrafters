import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_mentorship_service.dart';
import '../repositories/mentorship_repository.dart';
import '../models/mentor_model.dart';
import '../models/mentor_request_model.dart';
import 'auth_provider.dart';

final mentorshipServiceProvider = Provider<SupabaseMentorshipService>((ref) {
  return SupabaseMentorshipService(Supabase.instance.client);
});

final mentorshipRepositoryProvider = Provider<IMentorshipRepository>((ref) {
  final service = ref.watch(mentorshipServiceProvider);
  return MentorshipRepository(service);
});

final mentorListProvider = FutureProvider<List<MentorModel>>((ref) async {
  final repo = ref.watch(mentorshipRepositoryProvider);
  return await repo.getMentors();
});

class MentorRequestsState {
  final bool isLoading;
  final List<MentorRequestModel> requests;
  final String? errorMessage;

  const MentorRequestsState({
    this.isLoading = false,
    this.requests = const [],
    this.errorMessage,
  });

  MentorRequestsState copyWith({
    bool? isLoading,
    List<MentorRequestModel>? requests,
    String? errorMessage,
  }) {
    return MentorRequestsState(
      isLoading: isLoading ?? this.isLoading,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }
}

class MentorRequestsNotifier extends StateNotifier<MentorRequestsState> {
  final IMentorshipRepository _repository;
  final String _userId;

  MentorRequestsNotifier(this._repository, this._userId) : super(const MentorRequestsState()) {
    loadRequests();
  }

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getRequests(_userId);
      state = state.copyWith(isLoading: false, requests: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> bookSession({
    required String mentorId,
    required String studentName,
    required String message,
  }) async {
    state = state.copyWith(isLoading: true);
    final res = await _repository.bookSession(
      mentorId: mentorId,
      studentId: _userId,
      studentName: studentName,
      message: message,
    );
    await loadRequests();
    return res;
  }

  Future<bool> updateStatus(String requestId, String status, {String? meetingUrl}) async {
    state = state.copyWith(isLoading: true);
    final res = await _repository.respondToRequest(requestId, status, meetingUrl: meetingUrl);
    await loadRequests();
    return res;
  }
}

final mentorRequestsNotifierProvider = StateNotifierProvider.autoDispose<MentorRequestsNotifier, MentorRequestsState>((ref) {
  final repo = ref.watch(mentorshipRepositoryProvider);
  final currentUser = ref.watch(authControllerProvider).user;
  final userId = currentUser?.id ?? 'demo_user';
  return MentorRequestsNotifier(repo, userId);
});
