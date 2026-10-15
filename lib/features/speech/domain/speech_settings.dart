import 'package:equatable/equatable.dart';

enum VoiceGender {
  female('여성'),
  male('남성');

  const VoiceGender(this.label);

  final String label;
}

/// 로봇이 멘트를 읽는 목소리 설정.
///
/// temi SDK가 성별·속도·높낮이를 지원하는지는 실기에서 확인한다.
class SpeechSettings extends Equatable {
  const SpeechSettings({
    this.gender = VoiceGender.female,
    this.speed = 1.0,
    this.pitch = 0,
    this.volume = 6,
    this.commandWait = defaultCommandWait,
  });

  static const minSpeed = 0.5;
  static const maxSpeed = 2.0;
  static const minPitch = -10;
  static const maxPitch = 10;
  static const minVolume = 0;
  static const maxVolume = 10;

  /// 화면 글을 읽은 뒤 방문객이 누르지 않으면 할 수 있는 말을 안내하기까지
  /// 기다리는 시간.
  static const defaultCommandWait = Duration(seconds: 3);
  static const minCommandWait = Duration(seconds: 1);
  static const maxCommandWait = Duration(seconds: 10);

  final VoiceGender gender;

  /// 말하기 속도 배수 ([minSpeed]~[maxSpeed]).
  final double speed;

  /// 높낮이 ([minPitch]~[maxPitch], 0이 기본).
  final int pitch;

  /// 로봇 음량 ([minVolume]~[maxVolume]).
  final int volume;

  /// 음성 명령을 안내하기 전에 기다리는 시간 ([minCommandWait]~[maxCommandWait]).
  final Duration commandWait;

  SpeechSettings copyWith({
    VoiceGender? gender,
    double? speed,
    int? pitch,
    int? volume,
    Duration? commandWait,
  }) => SpeechSettings(
    gender: gender ?? this.gender,
    speed: speed ?? this.speed,
    pitch: pitch ?? this.pitch,
    volume: volume ?? this.volume,
    commandWait: commandWait ?? this.commandWait,
  );

  @override
  List<Object?> get props => [gender, speed, pitch, volume, commandWait];
}
