import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/admin_pin_repository.dart';
import 'admin_pin_state.dart';

/// 관리 모드 PIN 입력. 자릿수를 다 채우면 바로 확인한다.
class AdminPinCubit extends Cubit<AdminPinState> {
  AdminPinCubit(this._pins) : super(AdminPinState(length: _pins.length));

  final AdminPinRepository _pins;

  Future<void> press(String digit) async {
    if (state.isVerified || state.entered.length >= state.length) return;
    final entered = state.entered + digit;
    emit(state.copyWith(entered: entered, isWrong: false));
    if (entered.length < state.length) return;

    final ok = await _pins.verify(entered);
    // 틀리면 칸을 비우고 다시 입력받는다.
    emit(
      ok
          ? state.copyWith(isVerified: true)
          : state.copyWith(entered: '', isWrong: true),
    );
  }

  void backspace() {
    if (state.entered.isEmpty) return;
    emit(
      state.copyWith(
        entered: state.entered.substring(0, state.entered.length - 1),
        isWrong: false,
      ),
    );
  }
}
