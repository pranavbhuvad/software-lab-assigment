import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:software_lab/core/utils/app_validators.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/auth_models.dart';
import '../../infra/controllers/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
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
    if (success && mounted) context.go(AppRoutes.verifyOtp);
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
            Text('Forgot Password?', style: AppTextStyles.heading),
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
              hint: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              controller: _mobileCtrl,
              keyboardType: TextInputType.phone,
              validator: AppValidators.phone,
            ),
            SizedBox(height: 20.h),

            AuthButton(
              label: 'Send Code',
              onTap: _onSendCode,
              isLoading: state.isLoading,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}