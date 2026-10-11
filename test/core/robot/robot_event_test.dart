import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/robot_event.dart';

void main() {
  test('채널 Map을 이동 상태 이벤트로 바꾼다', () {
    final event = RobotEvent.fromMap({
      'type': 'goToStatus',
      'location': 'science_lab',
      'status': 'abort',
      'descriptionId': 1006,
    });

    expect(
      event,
      const GoToStatusChanged(
        location: 'science_lab',
        status: GoToStatus.abort,
        descriptionId: 1006,
      ),
    );
  });

  test('모르는 타입이나 상태는 null을 돌려준다', () {
    expect(RobotEvent.fromMap({'type': 'unknown'}), isNull);
    expect(
      RobotEvent.fromMap({
        'type': 'ttsStatus',
        'text': '안녕하세요',
        'status': 'weird',
      }),
      isNull,
    );
  });
}
