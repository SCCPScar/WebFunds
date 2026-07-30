import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/storage/secure_storage_service.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../application/usecases/check_session_usecase.dart';
import '../../application/usecases/get_biometric_preference_usecase.dart';
import '../../application/usecases/set_biometric_preference_usecase.dart';
import '../../application/usecases/sign_in_with_email_usecase.dart';
import '../../application/usecases/sign_out_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/biometric_preference_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../../infrastructure/repositories/secure_storage_biometric_preference_repository.dart';
import '../../infrastructure/repositories/supabase_session_repository.dart';

/// Dependency injection graph for the Auth feature. Riverpod providers
/// *are* the DI mechanism — no separate service locator is used.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(supabaseServiceProvider));
});

final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>((ref) {
  return SignInWithEmailUseCase(ref.watch(authRepositoryProvider));
});

/// Real, config-safe implementation — see `SupabaseSessionRepository`.
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SupabaseSessionRepository(ref.watch(supabaseServiceProvider));
});

final checkSessionUseCaseProvider = Provider<CheckSessionUseCase>((ref) {
  return CheckSessionUseCase(ref.watch(sessionRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(sessionRepositoryProvider));
});

final biometricPreferenceRepositoryProvider = Provider<BiometricPreferenceRepository>((ref) {
  return SecureStorageBiometricPreferenceRepository(ref.watch(secureStorageServiceProvider));
});

final getBiometricPreferenceUseCaseProvider = Provider<GetBiometricPreferenceUseCase>((ref) {
  return GetBiometricPreferenceUseCase(ref.watch(biometricPreferenceRepositoryProvider));
});

final setBiometricPreferenceUseCaseProvider = Provider<SetBiometricPreferenceUseCase>((ref) {
  return SetBiometricPreferenceUseCase(ref.watch(biometricPreferenceRepositoryProvider));
});