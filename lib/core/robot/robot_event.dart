import 'package:equatable/equatable.dart';

/// temi `OnGoToLocationStatusChangedListener`의 이동 상태.
enum GoToStatus { start, calculating, going, complete, abort, reposing }

/// temi `TtsListener`의 음성 출력 상태.
enum TtsStatus { started, completed, error, cancelled }

/// 로봇이 보내는 이벤트. 화면은 이 타입만 보고, 채널 Map 형식은 몰라도 된다.
sealed class RobotEvent extends Equatable {
  const RobotEvent();

  /// 채널로 받은 `{"type": ...}` Map을 이벤트로 바꾼다. 모르는 타입은 null.
  static RobotEvent? fromMap(Map<Object?, Object?> map) {
    switch (map['type']) {
      case 'robotReady':
        return RobotReadyChanged(isReady: map['isReady']! as bool);
      case 'goToStatus':
        final status = GoToStatus.values.asNameMap()[map['status']];
        if (status == null) return null;
        return GoToStatusChanged(
          location: map['location']! as String,
          status: status,
          descriptionId: map['descriptionId'] as int?,
        );
      case 'ttsStatus':
        final status = TtsStatus.values.asNameMap()[map['status']];
        if (status == null) return null;
        return TtsStatusChanged(text: map['text']! as String, status: status);
      case 'locationsUpdated':
        return LocationsUpdated(
          (map['locations']! as List<Object?>).cast<String>(),
        );
    }
    return null;
  }
}

final class RobotReadyChanged extends RobotEvent {
  const RobotReadyChanged({required this.isReady});

  final bool isReady;

  @override
  List<Object?> get props => [isReady];
}

final class GoToStatusChanged extends RobotEvent {
  const GoToStatusChanged({
    required this.location,
    required this.status,
    this.descriptionId,
  });

  final String location;
  final GoToStatus status;

  /// ABORT 등에서 temi가 넘겨주는 원인 코드.
  final int? descriptionId;

  @override
  List<Object?> get props => [location, status, descriptionId];
}

final class TtsStatusChanged extends RobotEvent {
  const TtsStatusChanged({required this.text, required this.status});

  final String text;
  final TtsStatus status;

  @override
  List<Object?> get props => [text, status];
}

final class LocationsUpdated extends RobotEvent {
  const LocationsUpdated(this.locations);

  final List<String> locations;

  @override
  List<Object?> get props => [locations];
}
