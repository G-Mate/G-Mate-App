import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/data/in_memory_admin_pin_repository.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_pin_change_cubit.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_pin_change_state.dart';

void main() {
  late InMemoryAdminPinRepository pins;
  late AdminPinChangeCubit cubit;

  setUp(() {
    pins = InMemoryAdminPinRepository(pin: '1234');
    cubit = AdminPinChangeCubit(pins);
  });
  tearDown(() => cubit.close());

  Future<void> type(String digits) async {
    for (final d in digits.split('')) {
      await cubit.press(d);
    }
  }

  test('지금 PIN을 확인하고 새 PIN을 두 번 넣으면 바꾼다', () async {
    await type('1234');
    expect(cubit.state.step, PinChangeStep.newPin);
    await type('5678');
    expect(cubit.state.step, PinChangeStep.confirm);
    await type('5678');
    expect(cubit.state.isDone, isTrue);
    expect(await pins.verify('5678'), isTrue);
    expect(await pins.verify('1234'), isFalse);
  });

  test('지금 PIN이 틀리면 다음 단계로 가지 않는다', () async {
    await type('0000');
    expect(cubit.state.step, PinChangeStep.current);
    expect(cubit.state.error, PinChangeError.wrongCurrent);
    expect(cubit.state.entered, isEmpty);

    await cubit.press('1');
    expect(cubit.state.error, isNull);
  });

  test('두 번 넣은 새 PIN이 다르면 새 PIN부터 다시 받고 바꾸지 않는다', () async {
    await type('1234');
    await type('5678');
    await type('5679');
    expect(cubit.state.step, PinChangeStep.newPin);
    expect(cubit.state.error, PinChangeError.mismatch);
    expect(await pins.verify('1234'), isTrue);

    await type('1111');
    await type('1111');
    expect(cubit.state.isDone, isTrue);
    expect(await pins.verify('1111'), isTrue);
  });
}
