import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/admin_pin_repository.dart';

/// 기기의 보안 저장소(Android Keystore로 암호화)에 두는 PIN 저장소.
///
/// 저장한 PIN이 없으면 [AdminPinRepository.defaultPin]으로 확인한다.
class SecureAdminPinRepository implements AdminPinRepository {
  SecureAdminPinRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _pinKey = 'admin_pin';
  static final _pinPattern = RegExp(
    '^[0-9]{${AdminPinRepository.pinLength}}\$',
  );

  @override
  int get length => AdminPinRepository.pinLength;

  @override
  Future<bool> verify(String input) async {
    final saved = await _storage.read(key: _pinKey);
    return input == (saved ?? AdminPinRepository.defaultPin);
  }

  @override
  Future<void> changePin(String pin) {
    if (!_pinPattern.hasMatch(pin)) {
      throw ArgumentError.value(
        pin,
        'pin',
        '숫자 ${AdminPinRepository.pinLength}자리여야 합니다',
      );
    }
    return _storage.write(key: _pinKey, value: pin);
  }
}
