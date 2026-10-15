import 'package:equatable/equatable.dart';

/// PIN 변경 단계.
enum PinChangeStep {
  /// 지금 PIN 확인.
  current,

  /// 새 PIN 입력.
  newPin,

  /// 새 PIN 한 번 더 입력.
  confirm,

  /// 저장 끝.
  done,
}

/// 방금 입력이 왜 안 됐는지.
enum PinChangeError {
  /// 지금 PIN이 틀림.
  wrongCurrent,

  /// 새 PIN 두 번이 서로 다름.
  mismatch,
}

class AdminPinChangeState extends Equatable {
  const AdminPinChangeState({
    required this.length,
    this.step = PinChangeStep.current,
    this.entered = '',
    this.error,
  });

  /// PIN 자릿수.
  final int length;
  final PinChangeStep step;
  final String entered;

  /// 다음 입력에서 지운다.
  final PinChangeError? error;

  bool get isDone => step == PinChangeStep.done;

  AdminPinChangeState copyWith({
    PinChangeStep? step,
    String? entered,
    PinChangeError? error,
    bool clearError = false,
  }) => AdminPinChangeState(
    length: length,
    step: step ?? this.step,
    entered: entered ?? this.entered,
    error: clearError ? null : error ?? this.error,
  );

  @override
  List<Object?> get props => [length, step, entered, error];
}
