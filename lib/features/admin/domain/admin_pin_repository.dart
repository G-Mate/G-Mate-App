/// 관리 모드 PIN 확인과 변경.
abstract interface class AdminPinRepository {
  /// 처음 PIN. 운영 전에 바꾼다.
  static const defaultPin = '0000';

  /// PIN 자릿수.
  static const pinLength = 4;

  /// PIN 자릿수. 입력 칸 수로 쓴다.
  int get length;

  Future<bool> verify(String pin);

  /// PIN을 [pin]으로 바꾼다. [pinLength]자리 숫자여야 한다.
  Future<void> changePin(String pin);
}
