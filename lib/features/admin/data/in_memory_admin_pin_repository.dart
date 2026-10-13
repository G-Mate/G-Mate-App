import '../domain/admin_pin_repository.dart';

/// 메모리에만 두는 PIN 저장소. 테스트에서 쓴다.
class InMemoryAdminPinRepository implements AdminPinRepository {
  InMemoryAdminPinRepository({this._pin = AdminPinRepository.defaultPin});

  String _pin;

  @override
  int get length => _pin.length;

  @override
  Future<bool> verify(String input) async => input == _pin;

  @override
  Future<void> changePin(String pin) async => _pin = pin;
}
