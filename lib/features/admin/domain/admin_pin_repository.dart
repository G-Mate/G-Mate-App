/// 관리 모드 PIN 확인.
abstract interface class AdminPinRepository {
  /// PIN 자릿수.
  int get length;

  Future<bool> verify(String pin);
}
