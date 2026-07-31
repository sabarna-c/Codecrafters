/// Environment Configuration for AlumniConnect+
/// Secure management of API endpoints and environment variables.
class EnvConfig {
  EnvConfig._();

  /// Supabase API Endpoint
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://demo-alumniconnect.supabase.co',
  );

  /// Supabase Anon Key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.demo_anon_key_alumni_connect',
  );

  /// Stripe Publishable Key (Test Mode)
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_51AlumniConnectTestKeyForBITCollegeDemo12345',
  );

  /// App Info
  static const String appName = 'AlumniConnect+';
  static const String collegeName = 'BIT College';
  static const String appVersion = '1.0.0';

  /// Feature Flags
  static const bool enableFirebasePush = true;
  static const bool enableStripePayments = true;
}
