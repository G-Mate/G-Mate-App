import 'package:equatable/equatable.dart';

/// 화면에서 알아듣는 말 하나. [phrases] 중 하나가 들어 있으면 [id] 명령이다.
class VoiceCommand extends Equatable {
  const VoiceCommand(this.id, this.phrases);

  /// 화면이 무엇을 할지 고르는 이름 (예: `start`, `place:science_lab`).
  final String id;
  final List<String> phrases;

  @override
  List<Object?> get props => [id, phrases];
}

/// 화면에서 읽어 줄 말 한 줄. [cue]가 있으면 읽기 전에 화면에 알린다
/// (예: 홈 카드를 반짝이게 하기).
class VoiceLine extends Equatable {
  const VoiceLine(this.text, {this.cue});

  final String text;
  final String? cue;

  @override
  List<Object?> get props => [text, cue];
}

/// 화면 하나의 음성 안내 대본.
///
/// 들어오면 [intro]를 차례로 읽고, 정한 시간 동안 방문객이 누르지 않으면
/// [hint](할 수 있는 말)를 읽은 뒤 듣는다. [commands] 중 하나를 알아들으면
/// 화면에 알린다.
class VoiceScript extends Equatable {
  const VoiceScript({
    this.intro = const [],
    this.hint,
    this.commands = const [],
    this.waitBeforeHint,
    this.hintRepeats = 2,
  });

  final List<VoiceLine> intro;

  /// 기다린 뒤 읽고 들을 말. null이면 묻지 않고, 들리는 명령만 받는다.
  final String? hint;
  final List<VoiceCommand> commands;

  /// [hint]까지 기다리는 시간. null이면 관리 모드 음성 설정 값을 쓴다.
  final Duration? waitBeforeHint;

  /// 대답이 없을 때 [hint]를 몇 번까지 안내할지.
  final int hintRepeats;

  /// [heard]에서 알아들은 명령. 여러 개면 가장 긴 말이 맞은 것을 고른다.
  VoiceCommand? match(String heard) {
    final h = normalizeSpeech(heard);
    if (h.isEmpty) return null;
    VoiceCommand? best;
    var bestLength = 0;
    for (final command in commands) {
      for (final phrase in command.phrases) {
        final p = normalizeSpeech(phrase);
        if (p.isNotEmpty && h.contains(p) && p.length > bestLength) {
          best = command;
          bestLength = p.length;
        }
      }
    }
    return best;
  }

  @override
  List<Object?> get props => [
    intro,
    hint,
    commands,
    waitBeforeHint,
    hintRepeats,
  ];
}

/// 띄어쓰기·문장 부호를 빼고 소문자로 바꾼다. 음성 인식 결과는 띄어쓰기가
/// 들쭉날쭉해서 '길찾기'와 '길 찾기'를 같게 본다.
String normalizeSpeech(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'[\s.,!?~·]'), '');
