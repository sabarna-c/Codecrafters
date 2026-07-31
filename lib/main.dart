import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

/// Provider for managing ThemeMode across the application
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom Global Flutter Error Handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global App Error: ${details.exceptionAsString()}');
  };

  // Safe Supabase Initialization
  try {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: EnvConfig.supabaseAnonKey,
      debug: false,
    );
  } catch (e) {
    debugPrint('Supabase Initialization Exception (Fallback Mode Active): $e');
  }

  runApp(
    const ProviderScope(
      child: AlumniConnectApp(),
    ),
  );
}

/// Root Application Widget
class AlumniConnectApp extends ConsumerWidget {
  const AlumniConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: EnvConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
