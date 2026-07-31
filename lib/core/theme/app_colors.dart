import 'package:flutter/material.dart';

/// Modern Material 3 Curated Color Palette for AlumniConnect+
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Royal Navy
  static const Color primaryBlueLight = Color(0xFF3B82F6); // Sapphire Accent
  static const Color secondaryEmerald = Color(0xFF059669); // Verified Alumni Emerald
  static const Color accentAmber = Color(0xFFD97706); // Warm Amber Highlight
  static const Color errorCrimson = Color(0xFFDC2626); // Alert Red

  // Light Mode Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Dark Mode Theme Colors
  static const Color darkBackground = Color(0xFF0B0F17);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Role Badge Colors
  static const Color studentBadge = Color(0xFF0284C7); // Sky Blue
  static const Color alumniBadge = Color(0xFF059669); // Emerald Green
  static const Color adminBadge = Color(0xFF7C3AED); // Purple Accent

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF047857), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
