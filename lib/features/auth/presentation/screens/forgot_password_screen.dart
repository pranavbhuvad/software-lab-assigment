import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:software_lab/core/utils/app_validators.dart';
import 'package:software_lab/features/auth/domain/state/auth_state.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/auth_models.dart';
import '../../infra/controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();

  @override
  void dispose() {
    _mobileCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSendCode() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .forgotPassword(ForgotPasswordRequest(mobile: _mobileCtrl.text.trim()));

    // ✅ Only navigate if truly successful
    if (success && mounted) context.go(AppRoutes.verifyOtp);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (_, next) {
      if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              // ── Strip exception prefix from error message ──
              next.error!
                  .replaceAll('AppException(API_ERROR): ', '')
                  .replaceAll('AppException(UNAUTHORIZED): ', '')
                  .replaceAll('AppException(REQUEST_ERROR): ', '')
                  .replaceAll('Exception: ', ''),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand name top-left (matching Figma)
                Text(
                  'FarmerEats',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                    fontFamily: AppTextStyles.fontFamilyBeVietnam,
                  ),
                ),
                SizedBox(height: 90.h),

                // Large bold heading (matching Figma)
                Text(
                  'Forgot Password?',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppTextStyles.fontFamilyBeVietnam,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 24.h),

                // Subtitle with Login link
                Row(
                  children: [
                    Text(
                      'Remember your password? ',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14.sp,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Text(
                        'Login',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 72.h),

                // Phone number field
                AuthTextField(
                  hint: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  controller: _mobileCtrl,
                  keyboardType: TextInputType.phone,
                  validator: AppValidators.phone,
                ),
                SizedBox(height: 32.h),

                // Send Code button
                AuthButton(
                  label: 'Send Code',
                  onTap: _onSendCode,
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
