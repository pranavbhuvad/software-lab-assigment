import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:software_lab/core/utils/app_validators.dart';
import 'package:software_lab/core/theme/app_colors.dart';
import 'package:software_lab/core/theme/app_text_styles.dart';
import 'package:software_lab/features/auth/presentation/widgets/auth_card.dart';
import 'package:software_lab/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:software_lab/features/auth/presentation/widgets/primary_button.dart';
import 'package:software_lab/features/auth/presentation/widgets/social_button.dart';
import 'package:software_lab/features/auth/presentation/widgets/step_header.dart';

class Step1Welcome extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameCtrl,
      emailCtrl,
      phoneCtrl,
      passwordCtrl,
      confirmPassCtrl;
  final VoidCallback onContinue, onLoginTap;

  const Step1Welcome({
    super.key,
    required this.formKey,
    required this.fullNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passwordCtrl,
    required this.confirmPassCtrl,
    required this.onContinue,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Step label + heading ──────────────────────────
            SizedBox(height: 16.h),
            Text(
              'Signup 1 of 4',
              style: AppTextStyles.caption.copyWith(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                fontFamily: AppTextStyles.fontFamilyBeVietnam,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Welcome!',
              style: AppTextStyles.heading.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
                fontFamily: AppTextStyles.fontFamilyBeVietnam,
              ),
            ),
            SizedBox(height: 40.h),

            // ── Social buttons ────────────────────────────────
            // ── Social buttons row ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _SocialIconButton(
                    onTap: () {},
                    child: _SocialNetworkImage(
                      url: 'https://www.google.com/favicon.ico',
                      size: 22,
                      fallback: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4285F4),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _SocialIconButton(
                    onTap: () {},
                    child: Icon(Icons.apple, size: 24.sp, color: Colors.black),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _SocialIconButton(
                    onTap: () {},
                    child: _SocialNetworkImage(
                      url: '',
                      size: 22,
                      fallback: Icon(
                        Icons.facebook,
                        size: 22.sp,
                        color: const Color(0xFF1877F2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // ── Divider text ──────────────────────────────────
            Center(
              child: Text(
                'or signup with',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12.sp,
                  color: Color.fromRGBO(38, 28, 18, 0.3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // ── Form fields ───────────────────────────────────
            _SignupField(
              hint: 'Full Name',
              prefixIcon: Icons.person_outline,
              controller: fullNameCtrl,
              validator: (v) => AppValidators.required(v, 'Full name'),
            ),
            SizedBox(height: 14.h),
            _SignupField(
              hint: 'Email Address',
              prefixIcon: Icons.alternate_email,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.email,
            ),
            SizedBox(height: 14.h),
            _SignupField(
              hint: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              validator: AppValidators.phone,
            ),
            SizedBox(height: 14.h),
            _SignupField(
              hint: 'Password',
              prefixIcon: Icons.lock_outline,
              controller: passwordCtrl,
              isPassword: true,
              validator: AppValidators.password,
            ),
            SizedBox(height: 14.h),
            _SignupField(
              hint: 'Re-enter Password',
              prefixIcon: Icons.lock_outline,
              controller: confirmPassCtrl,
              isPassword: true,
              validator: (v) =>
                  AppValidators.confirmPassword(passwordCtrl.text)(v),
            ),
            Spacer(),
            SizedBox(height: 32.h),

            // ── Bottom row: Login + Continue ──────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onLoginTap,
                  child: Text(
                    'Login',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 160.w,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }
}

// ── Private: consistent input field for signup ────────────────
class _SignupField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const _SignupField({
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_SignupField> createState() => _SignupFieldState();
}

class _SignupFieldState extends State<_SignupField> {
  bool _obscure = true;

  List<TextInputFormatter>? get _formatters {
    if (widget.keyboardType == TextInputType.phone) {
      return [
        FilteringTextInputFormatter.digitsOnly, // blocks letters/symbols
        LengthLimitingTextInputFormatter(10), // hard cap at 10 digits
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: _formatters,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textHint,
            fontWeight: FontWeight.w400,
            fontFamily: AppTextStyles.fontFamilyBeVietnam,
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 15.sp,
            color: AppColors.black,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 0),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18.sp,
                    color: AppColors.textHint,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.primary.withOpacity(0.4),
              width: 1.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          errorStyle: TextStyle(fontSize: 10.sp, height: 1.2),
        ),
      ),
    );
  }
}

// ── Private: social icon button ───────────────────────────────
class _SocialIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SocialIconButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r), // ← pill shape
          border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.08), width: 1),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ── Network image with fallback ────────────────────────────────
class _SocialNetworkImage extends StatelessWidget {
  final String url;
  final Widget fallback;
  final double size;

  const _SocialNetworkImage({
    required this.url,
    required this.fallback,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: size.w,
      height: size.w,
      fit: BoxFit.contain,
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: size.w,
          height: size.w,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.primary,
          ),
        );
      },
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
