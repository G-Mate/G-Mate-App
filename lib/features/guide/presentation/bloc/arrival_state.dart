import 'package:equatable/equatable.dart';

import '../../../place/domain/place.dart';

class ArrivalState extends Equatable {
  const ArrivalState({
    this.isLoading = true,
    this.place,
    this.lineIndex = 0,
    this.isSpeaking = false,
    this.isLineDone = false,
  });

  final bool isLoading;
  final Place? place;

  /// 지금 화면에 크게 보여 주는 줄.
  final int lineIndex;

  /// 로봇이 멘트를 읽는 중인지. 다 읽으면 false.
  final bool isSpeaking;

  /// 지금 줄을 다 읽고 다음 줄로 저절로 넘어가기를 기다리는 중인지.
  /// 이때 [다음] 버튼을 강조하고 남은 시간을 보여 준다.
  final bool isLineDone;

  /// 화면에 한 줄씩 보여 줄 설명. 본 설명이 비어 있으면 도착 멘트 한 줄.
  List<String> get lines {
    final p = place;
    if (p == null) return const [];
    final description = p.speech.descriptionLines;
    return description.isEmpty ? [p.speech.arrival] : description;
  }

  /// 지금 줄 다음에 더 읽을 줄이 있는지 ([다음] 버튼).
  bool get hasNext => lineIndex < lines.length - 1;

  ArrivalState copyWith({
    bool? isLoading,
    Place? place,
    int? lineIndex,
    bool? isSpeaking,
    bool? isLineDone,
  }) => ArrivalState(
    isLoading: isLoading ?? this.isLoading,
    place: place ?? this.place,
    lineIndex: lineIndex ?? this.lineIndex,
    isSpeaking: isSpeaking ?? this.isSpeaking,
    isLineDone: isLineDone ?? this.isLineDone,
  );

  @override
  List<Object?> get props => [
    isLoading,
    place,
    lineIndex,
    isSpeaking,
    isLineDone,
  ];
}
