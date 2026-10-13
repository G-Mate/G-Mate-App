import 'robot_event.dart';

/// temi 호출을 한곳에 모은 추상화. 화면과 도메인은 이 타입만 의존한다.
///
/// 구현은 실기용 `TemiRobotController`와 개발용 `FakeRobotController` 두 가지다.
abstract interface class RobotController {
  /// 이동·음성·장소 변경 등 로봇 이벤트.
  Stream<RobotEvent> get events;

  /// `onRobotReady(true)`를 받았는지. false면 다른 호출을 하지 않는다.
  Future<bool> isReady();

  /// temi에 저장된 장소 키 목록.
  Future<List<String>> getLocations();

  /// 현재 위치를 [key] 이름으로 저장한다. 키는 영문 소문자(`science_lab`).
  Future<void> saveLocation(String key);

  Future<void> deleteLocation(String key);

  /// [key] 장소로 이동을 시작한다. 진행은 [GoToStatusChanged]로 알 수 있다.
  Future<void> goTo(String key);

  Future<void> stopMovement();

  /// [text]를 읽기 시작한다. 진행은 [TtsStatusChanged]로 알 수 있다.
  Future<void> speak(String text);

  /// 읽고 있거나 읽으려고 기다리는 말을 모두 멈춘다.
  Future<void> cancelSpeech();

  /// [text]를 읽은 뒤 방문객의 말을 듣는다 (temi `askQuestion`).
  /// 알아들은 말은 [AsrResultReceived], 듣기 상태는 [ConversationStatusChanged]로 온다.
  Future<void> askQuestion(String text);

  /// 듣고 있던 것을 멈춘다.
  Future<void> finishConversation();

  Future<void> dispose();
}
