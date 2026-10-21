import 'package:equatable/equatable.dart';

enum VoicePhase {
  /// 아무것도 하지 않음 (안내를 마쳤거나 방문객이 화면을 누름).
  idle,

  /// 화면 글을 읽는 중.
  speaking,

  /// 할 수 있는 말을 안내하기 전에 방문객이 누르기를 기다리는 중.
  waiting,

  /// 할 수 있는 말을 안내하고 듣는 중.
  listening,

  /// 명령을 알아듣고, 알아들은 말을 잠깐 보여 준 뒤 수행하기를 기다리는 중.
  recognized,
}

class VoiceGuideState extends Equatable {
  const VoiceGuideState({
    this.phase = VoicePhase.idle,
    this.cue,
    this.cueCount = 0,
    this.command,
    this.commandCount = 0,
    this.recognized,
  });

  final VoicePhase phase;

  /// 마지막으로 화면에 알린 신호 (예: 카드 반짝임). [cueCount]가 늘 때마다 새 신호다.
  final String? cue;
  final int cueCount;

  /// 마지막으로 알아들은 명령 id. [commandCount]가 늘 때마다 새 명령이다.
  final String? command;
  final int commandCount;

  /// 알아들은 명령의 대표 말 (예: '투어 시작'). [VoicePhase.recognized]에서 보여 준다.
  final String? recognized;

  VoiceGuideState copyWith({
    VoicePhase? phase,
    String? cue,
    int? cueCount,
    String? command,
    int? commandCount,
    String? recognized,
  }) => VoiceGuideState(
    phase: phase ?? this.phase,
    cue: cue ?? this.cue,
    cueCount: cueCount ?? this.cueCount,
    command: command ?? this.command,
    commandCount: commandCount ?? this.commandCount,
    recognized: recognized ?? this.recognized,
  );

  @override
  List<Object?> get props => [
    phase,
    cue,
    cueCount,
    command,
    commandCount,
    recognized,
  ];
}
