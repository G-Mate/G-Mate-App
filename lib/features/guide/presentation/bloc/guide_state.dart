part of 'guide_bloc.dart';

enum GuidePhase {
  /// 장소를 불러오는 중.
  loading,

  /// 없는 장소.
  notFound,

  /// 목적지로 가는 중.
  moving,

  /// 도착. 화면은 도착·설명으로 넘어간다.
  arrived,

  /// 로봇이 이동을 포기함 (temi ABORT).
  failed,

  /// 방문객이 안내를 멈춤. 화면은 홈으로 돌아간다.
  stopped,
}

class GuideState extends Equatable {
  const GuideState({
    this.phase = GuidePhase.loading,
    this.place,
    this.progress = 0,
  });

  final GuidePhase phase;
  final Place? place;

  /// 경로를 얼마나 왔는지 (0~1). 지도에서 지나온 길과 로봇 위치를 그린다.
  ///
  /// 지금은 temi 이동 상태로 어림한다. 실제 위치를 받게 되면 그 값으로 바꾼다.
  final double progress;

  GuideState copyWith({GuidePhase? phase, Place? place, double? progress}) =>
      GuideState(
        phase: phase ?? this.phase,
        place: place ?? this.place,
        progress: progress ?? this.progress,
      );

  @override
  List<Object?> get props => [phase, place, progress];
}
