/// Application Constants for AlumniConnect+
class AppConstants {
  AppConstants._();

  // Roles
  static const String roleStudent = 'student';
  static const String roleAlumni = 'alumni';
  static const String roleAdmin = 'admin';

  // Storage Buckets
  static const String bucketAvatars = 'avatars';
  static const String bucketEventBanners = 'event_banners';
  static const String bucketDocuments = 'scholarship_docs';
  static const String bucketUtilizationReports = 'utilization_proofs';

  // Preference Keys
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyUserRole = 'user_role';
  static const String prefKeyRememberMe = 'remember_me';

  // Animation Durations
  static const Duration animDurationFast = Duration(milliseconds: 200);
  static const Duration animDurationNormal = Duration(milliseconds: 350);
  static const Duration animDurationSlow = Duration(milliseconds: 500);

  // Layout Boundaries
  static const double maxWebWidth = 1200.0;
  static const double maxCardWidth = 450.0;
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 16.0;
}
