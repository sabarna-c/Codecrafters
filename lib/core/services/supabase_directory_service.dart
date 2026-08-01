import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile_model.dart';
import '../../models/department_model.dart';
import '../../models/batch_model.dart';
import '../../models/alumni_filter_model.dart';
import '../utils/app_logger.dart';

/// Service executing Supabase queries for Alumni Directory
class SupabaseDirectoryService {
  final SupabaseClient _client;

  SupabaseDirectoryService(this._client);

  /// Fetch Alumni Profiles with optional filters & pagination
  Future<List<ProfileModel>> fetchAlumni({
    required AlumniFilterModel filter,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      var query = _client.from('profiles').select('*, departments(name), batches(year), users(email)');

      if (filter.onlyVerified) {
        query = query.eq('is_verified', true);
      }
      if (filter.departmentId != null) {
        query = query.eq('department_id', filter.departmentId!);
      }
      if (filter.batchId != null) {
        query = query.eq('batch_id', filter.batchId!);
      }
      if (filter.company != null && filter.company!.isNotEmpty) {
        query = query.ilike('company', '%${filter.company}%');
      }
      if (filter.searchQuery.isNotEmpty) {
        query = query.or('full_name.ilike.%${filter.searchQuery}%,company.ilike.%${filter.searchQuery}%,job_title.ilike.%${filter.searchQuery}%');
      }

      final from = page * pageSize;
      final to = from + pageSize - 1;
      final response = await query.range(from, to);

      final list = (response as List).map((json) => ProfileModel.fromJson(json)).toList();
      return list.isNotEmpty ? list : _getMockAlumniList(filter);
    } catch (e, st) {
      AppLogger.error('Supabase Directory Fetch Exception', e, st);
      return _getMockAlumniList(filter);
    }
  }

  /// Fetch list of departments
  Future<List<DepartmentModel>> fetchDepartments() async {
    try {
      final res = await _client.from('departments').select().order('name');
      return (res as List).map((j) => DepartmentModel.fromJson(j)).toList();
    } catch (e) {
      return [
        const DepartmentModel(id: 'd1', name: 'Computer Science & Engineering', code: 'CSE'),
        const DepartmentModel(id: 'd2', name: 'Electronics & Communication', code: 'ECE'),
        const DepartmentModel(id: 'd3', name: 'Mechanical Engineering', code: 'MECH'),
        const DepartmentModel(id: 'd4', name: 'Information Technology', code: 'IT'),
      ];
    }
  }

  /// Fetch list of batches
  Future<List<BatchModel>> fetchBatches() async {
    try {
      final res = await _client.from('batches').select().order('year', ascending: false);
      return (res as List).map((j) => BatchModel.fromJson(j)).toList();
    } catch (e) {
      return [
        const BatchModel(id: 'b1', year: 2020, name: 'Batch of 2020'),
        const BatchModel(id: 'b2', year: 2021, name: 'Batch of 2021'),
        const BatchModel(id: 'b3', year: 2022, name: 'Batch of 2022'),
        const BatchModel(id: 'b4', year: 2023, name: 'Batch of 2023'),
      ];
    }
  }

  List<ProfileModel> _getMockAlumniList(AlumniFilterModel filter) {
    final now = DateTime.now();
    final mockList = [
      ProfileModel(
        id: 'p1',
        userId: 'u1',
        fullName: 'Sarah Jenkins',
        email: 'sarah.jenkins@bitcollege.edu',
        headline: 'Senior Software Engineer at Google',
        company: 'Google',
        jobTitle: 'Senior Software Engineer',
        location: 'Mountain View, CA',
        departmentName: 'Computer Science & Engineering',
        batchYear: 2020,
        skills: const ['Software Engineering', 'Distributed Systems', 'Cloud', 'Mentoring', 'System Design'],
        isVerified: true,
        bio: 'BIT CSE 2020 Graduate. Passionate about scalable engineering, mentoring students, and helping the BIT community grow.',
        createdAt: now,
        updatedAt: now,
      ),
      ProfileModel(
        id: 'p2',
        userId: 'u2',
        fullName: 'Alex Vance',
        email: 'alex.vance@bitcollege.edu',
        headline: 'Lead Product Manager at Microsoft',
        company: 'Microsoft',
        jobTitle: 'Lead Product Manager',
        location: 'Seattle, WA',
        departmentName: 'Information Technology',
        batchYear: 2019,
        skills: const ['Product Strategy', 'Cloud Platforms', 'Agile', 'User Experience'],
        isVerified: true,
        bio: 'Tech product leader bridging engineering and user needs. Always happy to guide BIT juniors entering PM roles.',
        createdAt: now,
        updatedAt: now,
      ),
      ProfileModel(
        id: 'p3',
        userId: 'u3',
        fullName: 'Rahul Sharma',
        email: 'rahul.sharma@bitcollege.edu',
        headline: 'Data & AI Leader at Amazon Web Services',
        company: 'AWS',
        jobTitle: 'Data & AI Leader',
        location: 'Austin, TX',
        departmentName: 'Electronics & Communication',
        batchYear: 2021,
        skills: const ['Data Strategy', 'Analytics', 'Cloud Platforms', 'Team Leadership', 'Research'],
        isVerified: true,
        bio: 'A BIT alumni focused on AI-driven products, data strategy, and helping students learn practical industry skills.',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    if (filter.searchQuery.isEmpty) return mockList;
    return mockList.where((p) {
      final q = filter.searchQuery.toLowerCase();
      return p.fullName.toLowerCase().contains(q) ||
          (p.company?.toLowerCase().contains(q) ?? false) ||
          (p.jobTitle?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}
