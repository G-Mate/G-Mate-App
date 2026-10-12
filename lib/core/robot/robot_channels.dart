/// Kotlin 브리지(`RobotChannels.kt`)와 같은 값을 유지해야 하는 채널 이름.
abstract final class RobotChannels {
  /// Dart → Kotlin 명령.
  static const method = 'gmate/robot';

  /// Kotlin → Dart 이벤트.
  static const events = 'gmate/robot/events';
}
