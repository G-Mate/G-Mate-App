part of 'tour_bloc.dart';

sealed class TourEvent extends Equatable {
  const TourEvent();

  @override
  List<Object?> get props => [];
}

/// 화면에 들어오면 코스를 불러오고 첫 곳으로 출발한다.
final class TourStarted extends TourEvent {
  const TourStarted();
}

/// [도착했어요]: 로봇이 도착을 알리지 못했을 때 방문객이 직접 설명으로 넘긴다.
final class TourArrivalConfirmed extends TourEvent {
  const TourArrivalConfirmed();
}

/// [다음 장소] (마지막 곳이면 [투어 마치기]). 이동하지 못했을 때 [건너뛰기]도 같다.
final class TourNextRequested extends TourEvent {
  const TourNextRequested();
}

/// [다시 듣기]: 지금 곳의 설명을 처음부터 다시 읽는다.
final class TourReplayRequested extends TourEvent {
  const TourReplayRequested();
}

/// 이동하지 못했을 때 [다시 시도].
final class TourRetryRequested extends TourEvent {
  const TourRetryRequested();
}

/// [투어 중지].
final class TourStopRequested extends TourEvent {
  const TourStopRequested();
}

final class _TourRobotEventReceived extends TourEvent {
  const _TourRobotEventReceived(this.event);

  final RobotEvent event;

  @override
  List<Object?> get props => [event];
}
