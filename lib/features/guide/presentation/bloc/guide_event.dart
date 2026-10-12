part of 'guide_bloc.dart';

sealed class GuideEvent extends Equatable {
  const GuideEvent();

  @override
  List<Object?> get props => [];
}

/// 화면에 들어오면 장소를 불러오고 출발 멘트와 함께 이동을 시작한다.
final class GuideStarted extends GuideEvent {
  const GuideStarted();
}

/// [안내 중지].
final class GuideStopRequested extends GuideEvent {
  const GuideStopRequested();
}

/// 이동하지 못했을 때 [다시 시도].
final class GuideRetryRequested extends GuideEvent {
  const GuideRetryRequested();
}

final class _GuideRobotEventReceived extends GuideEvent {
  const _GuideRobotEventReceived(this.event);

  final RobotEvent event;

  @override
  List<Object?> get props => [event];
}
