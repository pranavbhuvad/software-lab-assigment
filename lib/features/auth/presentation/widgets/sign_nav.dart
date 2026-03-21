import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:software_lab/features/auth/presentation/widgets/primary_button.dart';
import 'package:software_lab/features/auth/presentation/widgets/sign_up.dart';

class SignupNavRow extends StatelessWidget {
  final VoidCallback onBack, onContinue;
  final String continueLabel;

  const SignupNavRow({
    super.key,
    required this.onBack,
    required this.onContinue,
    this.continueLabel = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SignupBackButton(onBack: onBack),
        SizedBox(width: 78.w),
        Expanded(
          child: PrimaryButton(label: continueLabel, onTap: onContinue),
        ),
      ],
    );
  }
}