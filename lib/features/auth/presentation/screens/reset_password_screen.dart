import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/auth_models.dart';
import '../../infra/controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final resetToken = ref.read(authControllerProvider).resetToken ?? '';
    final success = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(ResetPasswordRequest(
          token: resetToken,
          password: _passCtrl.text,
          cpassword: _confirmCtrl.text,
        ));
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Password reset successfully!'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16.w),
      ));
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (_, next) {
      if (next.hasError && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error!),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16.w),
        ));
      }
    });

    return AuthCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset Password', style: AppTextStyles.heading),
            SizedBox(height: 6.h),
            Row(
              children: [
                Text(
                  'Remember your password? ',
                  style: AppTextStyles.body.copyWith(fontSize: 12.sp),
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: Text(
                    'Login',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),

            AuthTextField(
              hint: 'New Password',
              prefixIcon: Icons.lock_outline,
              controller: _passCtrl,
              isPassword: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required.';
                if (v.length < 8) return 'Min 8 characters.';
                return null;
              },
            ),
            SizedBox(height: 12.h),

            AuthTextField(
              hint: 'Confirm New Password',
              prefixIcon: Icons.lock_outline,
              controller: _confirmCtrl,
              isPassword: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm password.';
                if (v != _passCtrl.text) return 'Passwords do not match.';
                return null;
              },
            ),
            SizedBox(height: 24.h),

            AuthButton(
              label: 'Submit',
              onTap: _onSubmit,
              isLoading: state.isLoading,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}