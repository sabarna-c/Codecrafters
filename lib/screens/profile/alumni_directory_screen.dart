import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/alumni_filter_model.dart';
import '../../providers/directory_provider.dart';
import '../../widgets/directory/alumni_card.dart';
import '../../widgets/directory/alumni_filter_sheet.dart';
import '../../widgets/common/skill_chip.dart';

class AlumniDirectoryScreen extends ConsumerStatefulWidget {
  const AlumniDirectoryScreen({super.key});

  @override
  ConsumerState<AlumniDirectoryScreen> createState() => _AlumniDirectoryScreenState();
}

class _AlumniDirectoryScreenState extends ConsumerState<AlumniDirectoryScreen> {
  final _searchController = TextEditingController();

  final List<String> _popularSkills = const [
    'Career Guidance',
    'Leadership',
    'Product',
    'Cloud',
    'Mentoring',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AlumniFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(alumniFilterProvider);
    final directoryState = ref.watch(alumniDirectoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BIT Alumni Directory'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filter.hasActiveFilters,
              child: const Icon(Icons.filter_list_rounded),
            ),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(alumniFilterProvider.notifier).state = filter.copyWith(searchQuery: val);
              },
              decoration: InputDecoration(
                hintText: 'Search by name, company, or title...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(alumniFilterProvider.notifier).state = filter.copyWith(searchQuery: '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _popularSkills.map((skill) {
                final isSelected = filter.selectedSkill == skill;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SkillChip(
                    label: skill,
                    isSelected: isSelected,
                    onTap: () {
                      final newSkill = isSelected ? null : skill;
                      ref.read(alumniFilterProvider.notifier).state = filter.copyWith(selectedSkill: newSkill);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.read(alumniDirectoryProvider.notifier).fetchAlumni();
              },
              child: directoryState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : directoryState.alumni.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: directoryState.alumni.length,
                          itemBuilder: (context, index) {
                            final alumni = directoryState.alumni[index];
                            return AlumniCard(
                              alumni: alumni,
                              onTap: () {
                                context.push('/directory/detail', extra: alumni);
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No Alumni Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Try adjusting your search terms or active filters.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              ref.read(alumniFilterProvider.notifier).state = const AlumniFilterModel();
            },
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }
}
