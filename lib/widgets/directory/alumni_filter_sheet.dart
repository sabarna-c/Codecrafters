import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/alumni_filter_model.dart';
import '../../providers/directory_provider.dart';
import '../common/custom_button.dart';

class AlumniFilterSheet extends ConsumerStatefulWidget {
  const AlumniFilterSheet({super.key});

  @override
  ConsumerState<AlumniFilterSheet> createState() => _AlumniFilterSheetState();
}

class _AlumniFilterSheetState extends ConsumerState<AlumniFilterSheet> {
  late AlumniFilterModel _currentFilter;
  final _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilter = ref.read(alumniFilterProvider);
    _companyController.text = _currentFilter.company ?? '';
  }

  @override
  void dispose() {
    _companyController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final updated = _currentFilter.copyWith(
      company: _companyController.text.trim().isNotEmpty ? _companyController.text.trim() : null,
    );
    ref.read(alumniFilterProvider.notifier).state = updated;
    Navigator.pop(context);
  }

  void _resetFilter() {
    ref.read(alumniFilterProvider.notifier).state = const AlumniFilterModel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deptsAsync = ref.watch(departmentsProvider);
    final batchesAsync = ref.watch(batchesProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Alumni Directory',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: _resetFilter, child: const Text('Reset All')),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            Text('Department', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            deptsAsync.when(
              data: (depts) => DropdownButtonFormField<String>(
                initialValue: _currentFilter.departmentId,
                decoration: const InputDecoration(hintText: 'All Departments'),
                items: depts
                    .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
                    .toList(),
                onChanged: (val) => setState(() => _currentFilter = _currentFilter.copyWith(departmentId: val)),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 16),
            Text('Batch Year', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            batchesAsync.when(
              data: (batches) => DropdownButtonFormField<String>(
                initialValue: _currentFilter.batchId,
                decoration: const InputDecoration(hintText: 'All Batches'),
                items: batches
                    .map((b) => DropdownMenuItem(value: b.id, child: Text('${b.year} (${b.name})')))
                    .toList(),
                onChanged: (val) => setState(() => _currentFilter = _currentFilter.copyWith(batchId: val)),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 16),
            Text('Company', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                hintText: 'e.g. Google, Microsoft, Amazon',
                prefixIcon: Icon(Icons.business_rounded),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Verified Alumni Only'),
              subtitle: const Text('Only show alumni verified by BIT Administration'),
              value: _currentFilter.onlyVerified,
              onChanged: (val) => setState(() => _currentFilter = _currentFilter.copyWith(onlyVerified: val)),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Apply Filters',
              onPressed: _applyFilter,
            ),
          ],
        ),
      ),
    );
  }
}
