import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/common/custom_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = AppConstants.roleStudent;

  @override
  void initState() {
    super.initState();
    final presetRole = ref.read(authControllerProvider).selectedRole;
    if (presetRole != null) {
      _selectedRole = presetRole;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      SnackbarUtils.showError(context, 'Passwords do not match');
      return;
    }

    final authNotifier = ref.read(authControllerProvider.notifier);
    final success = await authNotifier.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
      fullName: _fullNameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      context.push('/email-verification?email=${_emailController.text.trim()}');
    } else {
      final errorMsg = ref.read(authControllerProvider).errorMessage;
      SnackbarUtils.showError(context, errorMsg ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isWeb ? AppConstants.maxCardWidth : double.infinity,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join BIT Community',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connect with alumni, access jobs, mentorship and BIT events.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    CustomAuthTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (val) => AppValidators.validateName(val, 'Full Name'),
                    ),
                    const SizedBox(height: 16),
                    CustomAuthTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'name@bitcollege.edu',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    Text('I am registering as:', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: AppConstants.roleStudent, label: Text('Student'), icon: Icon(Icons.school_rounded)),
                        ButtonSegment(value: AppConstants.roleAlumni, label: Text('Alumni'), icon: Icon(Icons.workspace_premium_rounded)),
                      ],
                      selected: {_selectedRole},
                      onSelectionChanged: (val) => setState(() => _selectedRole = val.first),
                    ),
                    const SizedBox(height: 16),
                    CustomAuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      validator: AppValidators.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    CustomAuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_clock_outlined,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Create Account',
                      isLoading: authState.isLoading,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
