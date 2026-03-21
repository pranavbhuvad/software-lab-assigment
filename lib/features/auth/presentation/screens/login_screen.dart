import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_validators.dart';
import '../../domain/models/auth_models.dart';
import '../../infra/controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authControllerProvider.notifier)
        .login(
          LoginRequest(email: _emailCtrl.text.trim(), password: _passCtrl.text),
        );
    if (success && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (_, next) {
      if (next.hasError && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Brand header ──────────────────────────────────
              Row(
                children: [
                  SizedBox(
                    width: 36.w,
                    height: 36.h,

                    child: Icon(
                      Icons.eco_rounded,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'FarmerCats',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                      fontFamily: AppTextStyles.fontFamilyBeVietnam,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // ── Card ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 28.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Welcome back!',
                        style: AppTextStyles.heading.copyWith(
                          fontFamily: AppTextStyles.fontFamilyBeVietnam,
                          fontSize: 32.sp,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Text(
                            'New here? ',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTextStyles.fontFamilyBeVietnam,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.register),
                            child: Text(
                              'Create account',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTextStyles.fontFamilyBeVietnam,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 72.h),

                      // Email
                      AuthTextField(
                        hint: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                      ),
                      SizedBox(height: 24.h),

                      // Password row with Forgot? outside on right
                      AuthTextField(
                        hint: 'Password',
                        prefixIcon: Icons.lock_outline,
                        controller: _passCtrl,
                        isPassword: true,
                        validator: (v) => v == null || v.isEmpty
                            ? 'Password is required.'
                            : null,

                        suffixWidget: SizedBox(
                          width: 70.w, // 👈 control width
                          child: Padding(
                             padding: EdgeInsets.only(right: 16.w), 
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => context.go(AppRoutes.forgotPassword),
                                child: Text(
                                  'Forgot?',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Login button
                      AuthButton(
                        label: 'Login',
                        onTap: _onLogin,
                        isLoading: state.isLoading,
                      ),
                      SizedBox(height: 24.h),

                      // Divider
                      _buildDivider(),
                      SizedBox(height: 20.h),

                      // Social buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialBtn(
                              onTap: () {},
                              child: Image.network(
                                'https://www.google.com/favicon.ico',
                                width: 22.w,
                                height: 22.h,
                                errorBuilder: (_, __, ___) => Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF4285F4),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            _SocialBtn(
                              onTap: () {},
                              child: Icon(
                                Icons.apple,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            _SocialBtn(
                              onTap: () {},
                              child: Icon(
                                Icons.facebook,
                                size: 24.sp,
                                color: const Color(0xFF1877F2),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE8E8E8), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'or login with',
            style: AppTextStyles.body.copyWith(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE8E8E8), thickness: 1)),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _SocialBtn({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
