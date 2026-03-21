import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:software_lab/features/auth/infra/controllers/auth_controller.dart';
import 'package:software_lab/features/auth/presentation/widgets/step1_welcome.dart';
import 'package:software_lab/features/auth/presentation/widgets/step2_farmInfo.dart';
import 'package:software_lab/features/auth/presentation/widgets/step3_verification.dart';
import 'package:software_lab/features/auth/presentation/widgets/step4_business.dart';
import '../../../../core/routes/app_router.dart';


class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  // Step 1
  final _fullNameCtrl    = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _phoneCtrl       = TextEditingController();
  final _passwordCtrl    = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  // Step 2
  final _businessNameCtrl = TextEditingController();
  final _informalNameCtrl = TextEditingController();
  final _streetCtrl       = TextEditingController();
  final _cityCtrl         = TextEditingController();
  final _zipCtrl          = TextEditingController();

  String? _selectedState;
  String  _selectedDay = 'mon';

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    _businessNameCtrl.dispose();
    _informalNameCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _showSnackError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(16.w),
    ));
  }

  void _onStep1Continue() {
    if (!_step1Key.currentState!.validate()) return;
    final ctrl = ref.read(signupControllerProvider.notifier);
    ctrl.updateField('full_name', _fullNameCtrl.text.trim());
    ctrl.updateField('email',     _emailCtrl.text.trim());
    ctrl.updateField('phone',     _phoneCtrl.text.trim());
    ctrl.updateField('password',  _passwordCtrl.text);
    ctrl.nextStep();
  }

  void _onStep2Continue() {
    if (!_step2Key.currentState!.validate()) return;
    if (_selectedState == null) { _showSnackError('Please select a state'); return; }
    final ctrl = ref.read(signupControllerProvider.notifier);
    ctrl.updateField('business_name', _businessNameCtrl.text.trim());
    ctrl.updateField('informal_name', _informalNameCtrl.text.trim());
    ctrl.updateField('address',       _streetCtrl.text.trim());
    ctrl.updateField('city',          _cityCtrl.text.trim());
    ctrl.updateField('state',         _selectedState!);
    ctrl.updateField('zip_code',      _zipCtrl.text.trim());
    ctrl.nextStep();
  }

  void _onStep3Continue() {
    final proof = ref.read(signupControllerProvider).proofFile;
    if (proof == null) { _showSnackError('Please attach proof of registration'); return; }
    ref.read(signupControllerProvider.notifier).nextStep();
  }

  Future<void> _onSubmit() async {
    final success = await ref.read(signupControllerProvider.notifier).submit();
    if (success && mounted) context.go(AppRoutes.signupSuccess);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      ref.read(signupControllerProvider.notifier)
          .setProofFile(File(result.files.single.path!));
    }
  }

  void _removeFile() =>
      ref.read(signupControllerProvider.notifier).clearProofFile();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupControllerProvider);

    ref.listen(signupControllerProvider, (_, next) {
      if (next.error != null) {
        _showSnackError(next.error!);
        ref.read(signupControllerProvider.notifier).clearError();
      }
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: switch (state.step) {
        0 => Step1Welcome(
            key: const ValueKey(0),
            formKey: _step1Key,
            fullNameCtrl:    _fullNameCtrl,
            emailCtrl:       _emailCtrl,
            phoneCtrl:       _phoneCtrl,
            passwordCtrl:    _passwordCtrl,
            confirmPassCtrl: _confirmPassCtrl,
            onContinue:  _onStep1Continue,
            onLoginTap:  () => context.go(AppRoutes.login),
          ),
        1 => Step2FarmInfo(
            key: const ValueKey(1),
            formKey:          _step2Key,
            businessNameCtrl: _businessNameCtrl,
            informalNameCtrl: _informalNameCtrl,
            streetCtrl:       _streetCtrl,
            cityCtrl:         _cityCtrl,
            zipCtrl:          _zipCtrl,
            selectedState:    _selectedState,
            onStateChanged: (v) => setState(() => _selectedState = v),
            onContinue: _onStep2Continue,
            onBack: () => ref.read(signupControllerProvider.notifier).prevStep(),
          ),
        2 => Step3Verification(
            key: const ValueKey(2),
            file:         state.proofFile,
            onPickFile:   _pickFile,
            onRemoveFile: _removeFile,
            onContinue:   _onStep3Continue,
            onBack: () => ref.read(signupControllerProvider.notifier).prevStep(),
          ),
        3 => Step4BusinessHours(
            key: const ValueKey(3),
            state:       state,
            selectedDay: _selectedDay,
            onDayTap: (d) => setState(() => _selectedDay = d),
            onToggleSlot: (slot) => ref
                .read(signupControllerProvider.notifier)
                .toggleTimeSlot(_selectedDay, slot),
            isLoading: state.isLoading,
            onSubmit:  _onSubmit,
            onBack: () => ref.read(signupControllerProvider.notifier).prevStep(),
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}