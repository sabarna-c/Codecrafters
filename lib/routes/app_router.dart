import 'package:go_router/go_router.dart';
import '../models/profile_model.dart';
import '../models/mentor_model.dart';
import '../models/event_model.dart';
import '../models/donation_model.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/home/student_dashboard_screen.dart';
import '../screens/home/alumni_dashboard_screen.dart';
import '../screens/home/admin_dashboard_screen.dart';
import '../screens/profile/alumni_directory_screen.dart';
import '../screens/profile/alumni_profile_detail_screen.dart';
import '../screens/mentorship/mentorship_screen.dart';
import '../screens/mentorship/book_mentor_screen.dart';
import '../screens/mentorship/mentor_requests_screen.dart';
import '../screens/settings/admin_user_management_screen.dart';
import '../screens/settings/admin_broadcast_notification_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/events/event_detail_screen.dart';
import '../screens/events/qr_scanner_screen.dart';
import '../screens/donation/donation_screen.dart';
import '../screens/donation/donation_checkout_screen.dart';
import '../screens/donation/utilization_report_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String studentDashboard = '/student-dashboard';
  static const String alumniDashboard = '/alumni-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminBroadcast = '/admin/broadcast';
  static const String directory = '/directory';
  static const String directoryDetail = '/directory/detail';
  static const String mentorship = '/mentorship';
  static const String bookMentor = '/mentorship/book';
  static const String mentorRequests = '/mentorship/requests';
  static const String events = '/events';
  static const String eventDetail = '/events/detail';
  static const String eventScan = '/events/scan';
  static const String donation = '/donation';
  static const String settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (c, s) => const SplashScreen()),
    GoRoute(path: AppRoutes.onboarding, builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: AppRoutes.roleSelection, builder: (c, s) => const RoleSelectionScreen()),
    GoRoute(path: AppRoutes.login, builder: (c, s) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (c, s) => const RegisterScreen()),
    GoRoute(path: AppRoutes.forgotPassword, builder: (c, s) => const ForgotPasswordScreen()),
    GoRoute(
      path: AppRoutes.emailVerification,
      builder: (c, s) => EmailVerificationScreen(email: s.uri.queryParameters['email'] ?? ''),
    ),
    GoRoute(path: AppRoutes.studentDashboard, builder: (c, s) => const StudentDashboardScreen()),
    GoRoute(path: AppRoutes.alumniDashboard, builder: (c, s) => const AlumniDashboardScreen()),
    GoRoute(path: AppRoutes.adminDashboard, builder: (c, s) => const AdminDashboardScreen()),
    GoRoute(path: AppRoutes.adminUsers, builder: (c, s) => const AdminUserManagementScreen()),
    GoRoute(path: AppRoutes.adminBroadcast, builder: (c, s) => const AdminBroadcastNotificationScreen()),
    GoRoute(path: AppRoutes.directory, builder: (c, s) => const AlumniDirectoryScreen()),
    GoRoute(
      path: AppRoutes.directoryDetail,
      builder: (c, s) => AlumniProfileDetailScreen(alumni: s.extra as ProfileModel),
    ),
    GoRoute(path: AppRoutes.mentorship, builder: (c, s) => const MentorshipScreen()),
    GoRoute(
      path: AppRoutes.bookMentor,
      builder: (c, s) => BookMentorScreen(mentor: s.extra as MentorModel),
    ),
    GoRoute(path: AppRoutes.mentorRequests, builder: (c, s) => const MentorRequestsScreen()),
    GoRoute(path: AppRoutes.events, builder: (c, s) => const EventsScreen()),
    GoRoute(
      path: AppRoutes.eventDetail,
      builder: (c, s) => EventDetailScreen(event: s.extra as EventModel),
    ),
    GoRoute(path: AppRoutes.eventScan, builder: (c, s) => const QRScannerScreen()),
    GoRoute(path: AppRoutes.donation, builder: (c, s) => const DonationScreen()),
    GoRoute(
      path: '/donation/checkout/:causeId',
      builder: (c, s) => DonationCheckoutScreen(cause: s.extra as DonationCauseModel),
    ),
    GoRoute(
      path: '/donation/reports/:causeId',
      builder: (c, s) => UtilizationReportScreen(
        causeId: s.pathParameters['causeId']!,
        causeTitle: s.uri.queryParameters['title'] ?? 'Cause',
      ),
    ),
  ],
);
