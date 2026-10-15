import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/admin_pin_repository.dart';
import 'admin_pin_change_state.dart';

/// PIN 변경: 지금 PIN 확인 → 새 PIN → 새 PIN 한 번 더 → 저장.
///
/// 칸을 다 채우면 바로 다음 단계로 간다.
class AdminPinChangeCubit extends Cubit<AdminPinChangeState> {
  AdminPinChangeCubit(this._pins)
    : super(AdminPinChangeState(length: _pins.length));

  final AdminPinRepository _pins;

  /// 처음 넣은 새 PIN. 한 번 더 넣은 것과 비교한다.
  String _newPin = '';

  Future<void> press(String digit) async {
    if (state.isDone || state.entered.length >= state.length) return;
    final entered = state.entered + digit;
    emit(state.copyWith(entered: entered, clearError: true));
    if (entered.length < state.length) return;

    switch (state.step) {
      case PinChangeStep.current:
        final ok = await _pins.verify(entered);
        emit(
          ok
              ? state.copyWith(step: PinChangeStep.newPin, entered: '')
              : state.copyWith(entered: '', error: PinChangeError.wrongCurrent),
        );
      case PinChangeStep.newPin:
        _newPin = entered;
        emit(state.copyWith(step: PinChangeStep.confirm, entered: ''));
      case PinChangeStep.confirm:
        if (entered != _newPin) {
          // 처음부터 새 PIN을 다시 받는다.
          _newPin = '';
          emit(
            state.copyWith(
              step: PinChangeStep.newPin,
              entered: '',
              error: PinChangeError.mismatch,
            ),
          );
          return;
        }
        await _pins.changePin(entered);
        emit(state.copyWith(step: PinChangeStep.done));
      case PinChangeStep.done:
        return;
    }
  }

  void backspace() {
    if (state.entered.isEmpty) return;
    emit(
      state.copyWith(
        entered: state.entered.substring(0, state.entered.length - 1),
        clearError: true,
      ),
    );
  }
}
