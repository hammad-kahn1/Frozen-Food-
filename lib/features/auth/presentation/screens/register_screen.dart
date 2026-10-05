import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignUpWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.go(RouteNames.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state.isLoading;

              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // ── Back button ─────────────────────────────────
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.surfaceVariant),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded,
                                    size: 16, color: AppColors.onSurface),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),

                            const SizedBox(height: 24),

                            // ── Header ──────────────────────────────────────
                            const Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Start your frozen food journey today',
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.outline),
                            ),

                            const SizedBox(height: 32),

                            // ── Error / Success banners ──────────────────────
                            if (state.hasError) ...[
                              AuthErrorBanner(message: state.errorMessage!),
                              const SizedBox(height: 20),
                            ],
                            if (state.hasSuccess) ...[
                              AuthSuccessBanner(message: state.successMessage!),
                              const SizedBox(height: 20),
                            ],

                            // ── Display Name ─────────────────────────────────
                            AuthTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              hint: 'Ahmad Khan',
                              prefixIcon: Icons.person_outline_rounded,
                              focusNode: _nameFocus,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocus),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Full name is required';
                                }
                                if (v.trim().length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // ── Email ────────────────────────────────────────
                            AuthTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'you@example.com',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _emailFocus,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passwordFocus),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(v)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // ── Password ─────────────────────────────────────
                            AuthTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Min. 8 characters',
                              prefixIcon: Icons.lock_outline_rounded,
                              isPassword: true,
                              focusNode: _passwordFocus,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_confirmFocus),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                if (v.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(v)) {
                                  return 'Include at least one uppercase letter';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(v)) {
                                  return 'Include at least one number';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // ── Confirm Password ─────────────────────────────
                            AuthTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hint: 'Re-enter password',
                              prefixIcon: Icons.lock_outline_rounded,
                              isPassword: true,
                              focusNode: _confirmFocus,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _submit,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            // ── Terms note ───────────────────────────────────
                            const Text(
                              'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.outline),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // ── Sign up button ───────────────────────────────
                            AuthPrimaryButton(
                              onPressed: isLoading ? null : _submit,
                              label: 'Create Account',
                              isLoading: isLoading,
                            ),

                            const SizedBox(height: 24),
                            const AuthDivider(),
                            const SizedBox(height: 24),

                            // ── Google ───────────────────────────────────────
                            SocialSignInButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.read<AuthBloc>().add(
                                        const AuthSignInWithGoogleRequested(),
                                      ),
                              label: 'Sign up with Google',
                              icon: const Icon(Icons.g_mobiledata,
                                  size: 22, color: Color(0xFF4285F4)),
                            ),

                            const Spacer(),
                            const SizedBox(height: 24),

                            // ── Login link ───────────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                      color: AppColors.outline, fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
