import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> get canCheckBiometrics async {
    return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    try {
      if (!await canCheckBiometrics) return false;
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
      );
    } catch (e) {
      return false;
    }
  }
}
