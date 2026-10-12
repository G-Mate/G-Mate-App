import '../domain/admin_pin_repository.dart';

/// 정해진 PIN 하나로 확인하는 저장소. PIN 변경 화면(운영 설정)이 생기면
/// 로컬 저장으로 바꾼다.
class InMemoryAdminPinRepository implements AdminPinRepository {
  InMemoryAdminPinRepository({this.pin = defaultPin});

  /// 처음 PIN. 운영 전에 바꾼다.
  static const defaultPin = '0000';

  final String pin;

  @override
  int get length => pin.length;

  @override
  Future<bool> verify(String input) async => input == pin;
}
