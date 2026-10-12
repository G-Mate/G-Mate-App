import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/data/in_memory_admin_pin_repository.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_pin_cubit.dart';

void main() {
  AdminPinCubit build() =>
      AdminPinCubit(InMemoryAdminPinRepository(pin: '1234'));

  test('맞는 PIN을 다 넣으면 확인된다', () async {
    final cubit = build();
    for (final d in '1234'.split('')) {
      await cubit.press(d);
    }
    expect(cubit.state.isVerified, isTrue);
    await cubit.close();
  });

  test('틀리면 칸을 비우고 틀렸다고 알린다', () async {
    final cubit = build();
    for (final d in '1111'.split('')) {
      await cubit.press(d);
    }
    expect(cubit.state.isVerified, isFalse);
    expect(cubit.state.isWrong, isTrue);
    expect(cubit.state.entered, isEmpty);

    await cubit.press('1');
    expect(cubit.state.isWrong, isFalse);
    await cubit.close();
  });

  test('지우기는 마지막 숫자만 지운다', () async {
    final cubit = build();
    await cubit.press('1');
    await cubit.press('2');
    cubit.backspace();
    expect(cubit.state.entered, '1');
    await cubit.close();
  });
}
