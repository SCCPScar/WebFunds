import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/errors/app_exception.dart';

class BiometricService {
  const BiometricService(this._localAuth);

  final LocalAuthentication _localAuth;

  Future<bool> isAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } on Exception catch (e) {
      throw BiometricException('Não foi possível verificar a biometria do dispositivo.', cause: e);
    }
  }

  Future<List<BiometricType>> availableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on Exception catch (e) {
      throw BiometricException('Não foi possível listar os métodos biométricos.', cause: e);
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } on Exception catch (e) {
      throw BiometricException('A autenticação biométrica falhou.', cause: e);
    }
  }
}

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(LocalAuthentication());
});
