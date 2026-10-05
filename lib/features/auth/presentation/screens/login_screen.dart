import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthSignInWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
                            const SizedBox(height: 32),

                            // ── Brand / Hero ────────────────────────────────
                            _BrandHeader(),

                            const SizedBox(height: 36),

                            // ── Error banner ────────────────────────────────
                            if (state.hasError) ...[
                              AuthErrorBanner(message: state.errorMessage!),
                              const SizedBox(height: 20),
                            ],

                            // ── Email field ─────────────────────────────────
                            AuthTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'you@example.com',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              focusNode: _emailFocus,
                              onEditingComplete: () =>
                                  FocusScope.of(context).requestFocus(_passwordFocus),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(v)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // ── Password field ──────────────────────────────
                            AuthTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline_rounded,
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                              focusNode: _passwordFocus,
                              onEditingComplete: _submit,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                if (v.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 8),

                            // ── Forgot password link ────────────────────────
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    context.push(RouteNames.forgotPassword),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ── Sign in button ──────────────────────────────
                            AuthPrimaryButton(
                              onPressed: isLoading ? null : _submit,
                              label: 'Sign In',
                              isLoading: isLoading,
                            ),

                            const SizedBox(height: 24),
                            const AuthDivider(),
                            const SizedBox(height: 24),

                            // ── Google sign-in ──────────────────────────────
                            SocialSignInButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.read<AuthBloc>().add(
                                        const AuthSignInWithGoogleRequested(),
                                      ),
                              label: 'Continue with Google',
                              icon: _GoogleIcon(),
                            ),

                            const SizedBox(height: 12),

                            // ── Apple sign-in ───────────────────────────────
                            SocialSignInButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.read<AuthBloc>().add(
                                        const AuthSignInWithAppleRequested(),
                                      ),
                              label: 'Continue with Apple',
                              icon: const Icon(Icons.apple,
                                  size: 22, color: Colors.black),
                            ),

                            const Spacer(),
                            const SizedBox(height: 24),

                            // ── Register link ───────────────────────────────
                            _RegisterLink(),

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

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 24),
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in to continue ordering',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.outline,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: const Icon(Icons.g_mobiledata, size: 22, color: Color(0xFF4285F4)),
    );
  }
}

class _RegisterLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.outline, fontSize: 14),
        ),
        GestureDetector(
          onTap: () => context.push(RouteNames.register),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
