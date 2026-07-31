import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alumniconnect_plus/core/utils/validators.dart';

/// Standalone widget test that does NOT require Supabase initialization.
/// Tests a simple Material widget to verify the test framework works.
void main() {
  // ── Unit tests for AppValidators ─────────────────────────────────────────
  group('AppValidators Unit Tests', () {
    test('validateEmail: empty input returns required error', () {
      expect(
        AppValidators.validateEmail(''),
        equals('Email address is required'),
      );
    });

    test('validateEmail: invalid format returns format error', () {
      expect(
        AppValidators.validateEmail('not-an-email'),
        equals('Enter a valid email address (e.g. name@bitcollege.edu)'),
      );
    });

    test('validateEmail: valid email returns null', () {
      expect(AppValidators.validateEmail('admin@bitcollege.edu'), isNull);
    });

    test('validatePassword: short password returns length error', () {
      expect(
        AppValidators.validatePassword('abc'),
        equals('Password must be at least 8 characters long'),
      );
    });

    test('validatePassword: missing uppercase returns error', () {
      expect(
        AppValidators.validatePassword('lowercase123'),
        equals('Password must contain at least one uppercase letter'),
      );
    });

    test('validatePassword: missing digit returns error', () {
      expect(
        AppValidators.validatePassword('NoDigitsHere'),
        equals('Password must contain at least one digit'),
      );
    });

    test('validatePassword: strong password returns null', () {
      expect(AppValidators.validatePassword('StrongPass1'), isNull);
    });
  });

  // ── Smoke widget test ─────────────────────────────────────────────────────
  testWidgets('AlumniConnect+ renders a Material scaffold correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_rounded, size: 72, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'AlumniConnect+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('BIT College Alumni Platform'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('AlumniConnect+'), findsOneWidget);
    expect(find.text('BIT College Alumni Platform'), findsOneWidget);
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);
  });
}
