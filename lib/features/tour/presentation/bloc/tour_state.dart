part of 'tour_bloc.dart';

enum TourPhase {
  /// 코스를 불러오는 중.
  loading,

  /// 없는 코스이거나 들를 곳이 없음.
  notFound,

  /// 지금 곳으로 가는 중.
  moving,

  /// 지금 곳에 도착해 설명하는 중 (다 읽은 뒤에도 [다음 장소]를 기다린다).
  explaining,

  /// 로봇이 이동을 포기함 (temi ABORT).
  failed,

  /// 모든 곳을 둘러봄. 화면은 투어 끝으로 넘어간다.
  finished,

  /// 방문객이 투어를 멈춤. 화면은 홈으로 돌아간다.
  stopped,
}

class TourState extends Equatable {
  const TourState({
    this.phase = TourPhase.loading,
    this.tour,
    this.visits = const [],
    this.stopIndex = 0,
    this.lineIndex = 0,
    this.isSpeaking = false,
    this.isLineDone = false,
    this.progress = 0,
  });

  final TourPhase phase;
  final Tour? tour;
  final List<TourVisit> visits;

  /// 지금 들르는 곳 (0부터).
  final int stopIndex;

  /// 설명 중 지금 화면에 크게 보여 주는 줄.
  final int lineIndex;

  /// 로봇이 설명을 읽는 중인지. 다 읽으면 false.
  final bool isSpeaking;

  /// 지금 줄을 다 읽고 다음 줄로 넘어가기를 기다리는 중인지.
  final bool isLineDone;

  /// 지금 곳까지 경로를 얼마나 왔는지 (0~1).
  final double progress;

  TourVisit? get visit => stopIndex < visits.length ? visits[stopIndex] : null;

  /// 마지막 곳인지 ([다음 장소] 대신 [투어 마치기]).
  bool get isLastStop => stopIndex >= visits.length - 1;

  /// 지금 곳 설명에 다음 줄이 있는지.
  bool get hasNextLine {
    final visit = this.visit;
    return visit != null && lineIndex + 1 < visit.lines.length;
  }

  TourState copyWith({
    TourPhase? phase,
    Tour? tour,
    List<TourVisit>? visits,
    int? stopIndex,
    int? lineIndex,
    bool? isSpeaking,
    bool? isLineDone,
    double? progress,
  }) => TourState(
    phase: phase ?? this.phase,
    tour: tour ?? this.tour,
    visits: visits ?? this.visits,
    stopIndex: stopIndex ?? this.stopIndex,
    lineIndex: lineIndex ?? this.lineIndex,
    isSpeaking: isSpeaking ?? this.isSpeaking,
    isLineDone: isLineDone ?? this.isLineDone,
    progress: progress ?? this.progress,
  );

  @override
  List<Object?> get props => [
    phase,
    tour,
    visits,
    stopIndex,
    lineIndex,
    isSpeaking,
    isLineDone,
    progress,
  ];
}
