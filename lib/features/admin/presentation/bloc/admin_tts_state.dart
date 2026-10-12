import 'package:equatable/equatable.dart';

import '../../../speech/domain/speech_settings.dart';

class AdminTtsState extends Equatable {
  const AdminTtsState({
    this.isLoading = true,
    this.settings = const SpeechSettings(),
    this.saveCount = 0,
  });

  final bool isLoading;
  final SpeechSettings settings;

  /// 저장할 때마다 늘어난다. 화면이 저장 완료를 한 번씩 알리는 데 쓴다.
  final int saveCount;

  AdminTtsState copyWith({
    bool? isLoading,
    SpeechSettings? settings,
    int? saveCount,
  }) => AdminTtsState(
    isLoading: isLoading ?? this.isLoading,
    settings: settings ?? this.settings,
    saveCount: saveCount ?? this.saveCount,
  );

  @override
  List<Object?> get props => [isLoading, settings, saveCount];
}
