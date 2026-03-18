import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // Font families
  static const String fontFamilyNunito = 'Nunito';
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyBeVietnam = 'Be Vietnam';

  // Primary font used across the app
  static const String _font = fontFamilyNunito;

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
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get login => TextStyle(
        fontFamily: _font,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.loginText,
      );
}