import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const SocialButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 46.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Center(child: icon),
      ),
    );
  }
}

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF4285F4),
      ),
    );
  }
}

class AppleIcon extends StatelessWidget {
  const AppleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.apple, size: 24.sp, color: Colors.black);
  }
}

class FacebookIcon extends StatelessWidget {
  const FacebookIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'f',
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1877F2),
      ),
    );
  }
}