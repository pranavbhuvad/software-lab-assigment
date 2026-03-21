import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:software_lab/features/auth/infra/controllers/auth_controller.dart';

import 'package:software_lab/features/auth/infra/repositories/auth_repository.dart';



final signupControllerProvider =
    StateNotifierProvider<SignupController, SignupState>((ref) {
  return SignupController(ref.read(authRepositoryProvider));
});