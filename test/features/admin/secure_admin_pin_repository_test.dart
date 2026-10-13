import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/data/secure_admin_pin_repository.dart';
import 'package:g_mate/features/admin/domain/admin_pin_repository.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('저장한 PIN이 없으면 처음 PIN으로 확인한다', () async {
    final repo = SecureAdminPinRepository();
    expect(repo.length, AdminPinRepository.pinLength);
    expect(await repo.verify(AdminPinRepository.defaultPin), isTrue);
    expect(await repo.verify('1234'), isFalse);
  });

  test('바꾼 PIN은 새로 만든 저장소에서도 맞다', () async {
    await SecureAdminPinRepository().changePin('2468');

    final repo = SecureAdminPinRepository();
    expect(await repo.verify('2468'), isTrue);
    expect(await repo.verify(AdminPinRepository.defaultPin), isFalse);
  });

  test('숫자 4자리가 아니면 바꾸지 않는다', () async {
    final repo = SecureAdminPinRepository();
    expect(() => repo.changePin('12a4'), throwsArgumentError);
    expect(() => repo.changePin('123'), throwsArgumentError);
    expect(await repo.verify(AdminPinRepository.defaultPin), isTrue);
  });
}
