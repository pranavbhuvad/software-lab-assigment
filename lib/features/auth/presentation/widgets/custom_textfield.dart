import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final String? initialValue;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixWidget,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  List<TextInputFormatter>? get _formatters {
    if (widget.keyboardType == TextInputType.phone) {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      obscureText: widget.isPassword && _obscure,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: _formatters,
      onChanged: widget.onChanged,
      style: AppTextStyles.body.copyWith(
        color: AppColors.textPrimary,
        fontSize: 13.sp,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.textHint,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Icon(
            widget.prefixIcon,
            size: 15.sp,
            color: AppColors.black
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 0),
        suffixIcon: widget.suffixWidget ??
            (widget.isPassword
                ? GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  )
                : null),
        suffixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 0),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
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
            color: AppColors.primary.withOpacity(0.5),
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
        errorStyle: TextStyle(fontSize: 10.sp),
      ),
    );
  }
}