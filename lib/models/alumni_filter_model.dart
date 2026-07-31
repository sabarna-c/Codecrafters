/// Alumni Filter Criteria Model
class AlumniFilterModel {
  final String searchQuery;
  final String? departmentId;
  final String? batchId;
  final String? company;
  final String? selectedSkill;
  final bool onlyVerified;

  const AlumniFilterModel({
    this.searchQuery = '',
    this.departmentId,
    this.batchId,
    this.company,
    this.selectedSkill,
    this.onlyVerified = false,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      departmentId != null ||
      batchId != null ||
      (company != null && company!.isNotEmpty) ||
      (selectedSkill != null && selectedSkill!.isNotEmpty) ||
      onlyVerified;

  AlumniFilterModel copyWith({
    String? searchQuery,
    String? departmentId,
    String? batchId,
    String? company,
    String? selectedSkill,
    bool? onlyVerified,
  }) {
    return AlumniFilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
      departmentId: departmentId ?? this.departmentId,
      batchId: batchId ?? this.batchId,
      company: company ?? this.company,
      selectedSkill: selectedSkill ?? this.selectedSkill,
      onlyVerified: onlyVerified ?? this.onlyVerified,
    );
  }

  AlumniFilterModel reset() {
    return const AlumniFilterModel();
  }
}
