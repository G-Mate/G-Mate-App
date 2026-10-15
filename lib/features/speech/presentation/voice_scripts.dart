import '../../place/domain/place.dart';
import '../domain/voice_script.dart';

/// 화면별 음성 안내 대본. 화면 글과 같은 말을 읽고, 할 수 있는 말을 안내한다.
abstract final class VoiceScripts {
  /// 홈 카드가 반짝일 때 쓰는 신호.
  static const flashCue = 'flash';

  static const guideCommand = 'guide';
  static const tourCommand = 'tour';
  static const overviewCommand = 'overview';

  static const homeCommands = [
    VoiceCommand(guideCommand, ['길 찾기', '길 안내', '길']),
    VoiceCommand(tourCommand, ['학교 투어', '투어']),
    VoiceCommand(overviewCommand, ['학교 개요', '학교 소개', '개요']),
  ];

  /// 홈: 인사 → 가운데 카드 반짝임과 함께 카드 글 → 기다린 뒤 메뉴 안내.
  static VoiceScript home(String cardText) => VoiceScript(
    intro: [
      const VoiceLine('무엇을 도와드릴까요? 원하는 메뉴를 골라 주세요.'),
      VoiceLine(cardText, cue: flashCue),
    ],
    hint: '길 찾기, 학교 투어, 학교 개요 중에 원하시는 메뉴를 말씀해 주세요.',
    commands: homeCommands,
  );

  /// 홈 카드 하나를 읽는 말 (예: '길 찾기. 가고 싶은 곳까지 데려다 드려요').
  static String card(String title, String description) =>
      '$title. $description';

  static const listCommand = 'list';
  static const placePrefix = 'place:';

  /// 장소 선택: '길 찾기. 어디로 갈까요?' → 기다린 뒤 장소 목록 안내.
  static VoiceScript placeSelect(List<Place> places) => VoiceScript(
    intro: const [VoiceLine('길 찾기. 어디로 갈까요?')],
    hint:
        '어떤 장소가 있는지 알고 싶으시면 장소 목록이라고 말씀해 주세요. '
        '가고 싶은 장소 이름을 말씀하셔도 돼요.',
    commands: [
      const VoiceCommand(listCommand, ['장소 목록', '목록', '어디 있어']),
      for (final p in places)
        VoiceCommand('$placePrefix${p.key}', [p.name, ...p.keywords]),
    ],
  );

  /// 장소 목록을 읽어 주는 말.
  static String placeList(List<Place> places) =>
      '갈 수 있는 곳은 ${places.map((p) => p.name).join(', ')}이에요. '
      '가고 싶은 곳 이름을 말씀해 주세요.';

  static const startCommand = 'start';
  static const cancelCommand = 'cancel';

  /// 장소 확인: '과학실. 이곳으로 안내할까요?' → 기다린 뒤 안내 시작·취소 안내.
  static VoiceScript placeConfirm(Place place) => VoiceScript(
    intro: [VoiceLine('${place.name}. 이곳으로 안내할까요?')],
    hint:
        '안내 시작을 원하시면 안내 시작, '
        '다른 곳을 선택하고 싶으시면 취소라고 말씀해 주세요.',
    commands: const [
      VoiceCommand(startCommand, ['안내 시작', '시작', '출발']),
      VoiceCommand(cancelCommand, ['취소', '다른 곳']),
    ],
  );

  static const stopCommand = 'stop';

  /// 이동 중: 출발 멘트 뒤에 '안내 중지'로 멈출 수 있다고 알리고 듣는다.
  /// 그 뒤에도 temi를 불러 '안내 중지'라고 하면 멈춘다.
  static const guiding = VoiceScript(
    hint: '안내를 멈추고 싶으시면 언제든 안내 중지라고 말씀해 주세요.',
    waitBeforeHint: Duration.zero,
    hintRepeats: 1,
    commands: [
      VoiceCommand(stopCommand, ['안내 중지', '안내 그만', '멈춰', '중지']),
    ],
  );

  static const listenCommand = 'listen';
  static const doneCommand = 'done';

  /// 도착: 도착 멘트 뒤 기다렸다가 설명 듣기·마침 안내.
  static const arrival = VoiceScript(
    hint:
        '설명을 들으시려면 설명 듣기, '
        '처음 화면으로 가시려면 마침이라고 말씀해 주세요.',
    commands: [
      VoiceCommand(listenCommand, ['설명 듣기', '설명', '들을래']),
      VoiceCommand(doneCommand, ['마침', '처음으로', '처음 화면', '괜찮아']),
    ],
  );
}
