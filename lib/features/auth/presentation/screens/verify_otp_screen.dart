import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _onSubmit() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter the 6-digit OTP.'),
      ));
      return;
    }
    final success = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(VerifyOtpRequest(otp: _otp));
    if (success && mounted) context.go(AppRoutes.resetPassword);
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 58.h),
          Text('Verify OTP', 
          style: AppTextStyles.heading.copyWith(
            fontFamily: AppTextStyles.fontFamilyBeVietnam,
            fontSize: 32.sp,
            fontWeight: FontWeight.w700
          )
          ),
          SizedBox(height: 24.h),
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
          SizedBox(height: 72.h),

          // 6 OTP boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (i) => SizedBox(
                width: 44.w,
                height: 50.h,
                child: TextFormField(
                  controller: _controllers[i],
                  focusNode: _nodes[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.heading.copyWith(fontSize: 18.sp),
                  onChanged: (v) => _onOtpChanged(i, v),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFFF8F8F8),
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          AuthButton(
            label: 'Submit',
            onTap: _onSubmit,
            isLoading: state.isLoading,
          ),
          SizedBox(height: 16.h),

          Center(
            child: GestureDetector(
              onTap: () => context.go(AppRoutes.forgotPassword),
              child: Text(
                'Resend Code',
                style: AppTextStyles.body.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}