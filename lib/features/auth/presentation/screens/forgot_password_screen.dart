import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthPasswordResetRequested(
          email: _emailController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthErrorCleared());
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface, size: 20),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.passwordResetSent) {
              // Optionally navigate away after a delay, or let the user tap back
            }
          },
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
                          const SizedBox(height: 16),

                          // ── Header ────────────────────────────────────────
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 28),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Enter the email associated with your account and we\'ll send you a link to reset your password.',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.outline,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Banners ───────────────────────────────────────
                          if (state.hasError) ...[
                            AuthErrorBanner(message: state.errorMessage!),
                            const SizedBox(height: 20),
                          ],
                          if (state.hasSuccess) ...[
                            AuthSuccessBanner(message: state.successMessage!),
                            const SizedBox(height: 20),
                          ],

                          // ── Email Field ───────────────────────────────────
                          AuthTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'you@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            focusNode: _emailFocus,
                            onEditingComplete: _submit,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // ── Submit Button ─────────────────────────────────
                          AuthPrimaryButton(
                            onPressed: isLoading || state.status == AuthStatus.passwordResetSent
                                ? null
                                : _submit,
                            label: 'Send Reset Link',
                            isLoading: isLoading,
                          ),

                          const Spacer(),
                          const SizedBox(height: 24),
                          
                          // ── Back to Login ─────────────────────────────────
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(const AuthErrorCleared());
                                context.pop();
                              },
                              child: const Text(
                                'Return to Sign In',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
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
    );
  }
}
