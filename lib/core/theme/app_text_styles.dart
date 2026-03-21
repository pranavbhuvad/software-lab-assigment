import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // ── Font Families ──────────────────────────────────────────────
  static const String fontFamilyNunito     = 'Nunito';
  static const String fontFamilyInter      = 'Inter';
  static const String fontFamilyBeVietnam  = 'Be Vietnam';
  static const String fontFamilyBeVietnamPro = 'BeVietnamPro';

  // Primary font used across the app
  static const String _font = fontFamilyBeVietnam;

  // ── Onboarding / General Styles (Nunito) ──────────────────────
  static TextStyle get heading => TextStyle(
        fontFamily: _font,
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get body => TextStyle(
        fontFamily: _font,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
        letterSpacing: 0.1,
      );

  static TextStyle get button => TextStyle(
        fontFamily: _font,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get login => TextStyle(
        fontFamily: _font,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.loginText,
      );

  // ── Auth / Signup Styles (BeVietnamPro) ───────────────────────
  static TextStyle get authHeading => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get subHeading => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get authBody => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get authButton => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get stepLabel => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.2,
      );

  static TextStyle get brandName => TextStyle(
        fontFamily: fontFamilyBeVietnamPro,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );
}