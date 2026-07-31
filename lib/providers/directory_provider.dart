import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_directory_service.dart';
import '../repositories/directory_repository.dart';
import '../models/profile_model.dart';
import '../models/department_model.dart';
import '../models/batch_model.dart';
import '../models/alumni_filter_model.dart';

final directoryServiceProvider = Provider<SupabaseDirectoryService>((ref) {
  return SupabaseDirectoryService(Supabase.instance.client);
});

final directoryRepositoryProvider = Provider<DirectoryRepository>((ref) {
  final service = ref.watch(directoryServiceProvider);
  return DirectoryRepository(service);
});

final alumniFilterProvider = StateProvider<AlumniFilterModel>((ref) {
  return const AlumniFilterModel();
});

class DirectoryState {
  final bool isLoading;
  final List<ProfileModel> alumni;
  final String? errorMessage;
  final bool hasMore;

  const DirectoryState({
    this.isLoading = false,
    this.alumni = const [],
    this.errorMessage,
    this.hasMore = true,
  });

  DirectoryState copyWith({
    bool? isLoading,
    List<ProfileModel>? alumni,
    String? errorMessage,
    bool? hasMore,
  }) {
    return DirectoryState(
      isLoading: isLoading ?? this.isLoading,
      alumni: alumni ?? this.alumni,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class DirectoryNotifier extends StateNotifier<DirectoryState> {
  final DirectoryRepository _repository;
  final AlumniFilterModel _filter;

  DirectoryNotifier(this._repository, this._filter) : super(const DirectoryState()) {
    fetchAlumni();
  }

  Future<void> fetchAlumni() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getAlumni(filter: _filter);
      state = state.copyWith(isLoading: false, alumni: list, hasMore: list.length >= 20);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> toggleFollow(String userId) async {
    final isNowFollowing = await _repository.toggleFollowAlumni(userId);
    state = state.copyWith(); // Trigger state update
    return isNowFollowing;
  }
}

final alumniDirectoryProvider = StateNotifierProvider.autoDispose<DirectoryNotifier, DirectoryState>((ref) {
  final repo = ref.watch(directoryRepositoryProvider);
  final filter = ref.watch(alumniFilterProvider);
  return DirectoryNotifier(repo, filter);
});

final departmentsProvider = FutureProvider<List<DepartmentModel>>((ref) async {
  final repo = ref.watch(directoryRepositoryProvider);
  return await repo.getDepartments();
});

final batchesProvider = FutureProvider<List<BatchModel>>((ref) async {
  final repo = ref.watch(directoryRepositoryProvider);
  return await repo.getBatches();
});
