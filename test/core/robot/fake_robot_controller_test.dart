import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/fake_robot_controller.dart';
import 'package:g_mate/core/robot/robot_event.dart';

void main() {
  late FakeRobotController robot;

  setUp(() {
    robot = FakeRobotController(
      initialLocations: const ['science_lab'],
      stepDelay: Duration.zero,
    );
  });

  tearDown(() => robot.dispose());

  test('저장된 장소로 가면 START부터 COMPLETE까지 순서대로 보낸다', () async {
    final statuses = robot.events
        .whereType<GoToStatusChanged>()
        .map((e) => e.status)
        .take(4)
        .toList();

    await robot.goTo('science_lab');

    expect(await statuses, [
      GoToStatus.start,
      GoToStatus.calculating,
      GoToStatus.going,
      GoToStatus.complete,
    ]);
  });

  test('저장되지 않은 장소로 가면 ABORT를 보낸다', () async {
    final statuses = robot.events
        .whereType<GoToStatusChanged>()
        .map((e) => e.status)
        .take(2)
        .toList();

    await robot.goTo('unknown');

    expect(await statuses, [GoToStatus.start, GoToStatus.abort]);
  });

  test('장소를 저장하면 목록과 이벤트에 반영된다', () async {
    final updated = robot.events.whereType<LocationsUpdated>().first;

    await robot.saveLocation('library');

    expect(await robot.getLocations(), ['library', 'science_lab']);
    expect(await updated, const LocationsUpdated(['library', 'science_lab']));
  });
}

extension<T> on Stream<T> {
  Stream<S> whereType<S>() => where((e) => e is S).cast<S>();
}
