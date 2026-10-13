import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/robot/robot_channels.dart';
import 'package:g_mate/core/robot/robot_event.dart';
import 'package:g_mate/core/robot/temi_robot_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const method = MethodChannel(RobotChannels.method);
  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    messenger.setMockMethodCallHandler(method, (call) async {
      calls.add(call);
      return switch (call.method) {
        'isReady' => true,
        'getLocations' => ['home_base', 'science_lab'],
        _ => null,
      };
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(method, null));

  test('명령을 temi SDK 메서드 이름과 인자로 Kotlin에 보낸다', () async {
    final robot = TemiRobotController();

    expect(await robot.isReady(), isTrue);
    expect(await robot.getLocations(), ['home_base', 'science_lab']);
    await robot.goTo('science_lab');
    await robot.stopMovement();
    await robot.speak('안녕하세요');
    await robot.saveLocation('music_room');
    await robot.deleteLocation('music_room');

    expect(calls.map((c) => [c.method, c.arguments]), [
      ['isReady', null],
      ['getLocations', null],
      [
        'goTo',
        {'key': 'science_lab'},
      ],
      ['stopMovement', null],
      [
        'speak',
        {'text': '안녕하세요'},
      ],
      [
        'saveLocation',
        {'key': 'music_room'},
      ],
      [
        'deleteLocation',
        {'key': 'music_room'},
      ],
    ]);
  });

  test('준비 전 명령은 Kotlin의 NOT_READY 오류를 그대로 알린다', () async {
    messenger.setMockMethodCallHandler(method, (call) async {
      throw PlatformException(code: 'NOT_READY');
    });

    expect(
      TemiRobotController().goTo('science_lab'),
      throwsA(
        isA<PlatformException>().having((e) => e.code, 'code', 'NOT_READY'),
      ),
    );
  });

  test('이벤트 채널의 Map을 타입 있는 이벤트로 바꾸고 모르는 것은 버린다', () async {
    const codec = StandardMethodCodec();
    final raw = <Map<String, Object?>>[
      {'type': 'robotReady', 'isReady': true},
      {
        'type': 'goToStatus',
        'location': 'science_lab',
        'status': 'complete',
        'descriptionId': 0,
      },
      {'type': 'unknown'},
      {'type': 'ttsStatus', 'text': '도착했어요', 'status': 'completed'},
    ];
    messenger.setMockMessageHandler(RobotChannels.events, (message) async {
      final call = codec.decodeMethodCall(message);
      if (call.method == 'listen') {
        for (final event in raw) {
          await messenger.handlePlatformMessage(
            RobotChannels.events,
            codec.encodeSuccessEnvelope(event),
            (_) {},
          );
        }
      }
      return codec.encodeSuccessEnvelope(null);
    });
    addTearDown(
      () => messenger.setMockMessageHandler(RobotChannels.events, null),
    );

    final events = await TemiRobotController().events.take(3).toList();

    expect(events, const [
      RobotReadyChanged(isReady: true),
      GoToStatusChanged(
        location: 'science_lab',
        status: GoToStatus.complete,
        descriptionId: 0,
      ),
      TtsStatusChanged(text: '도착했어요', status: TtsStatus.completed),
    ]);
  });
}
