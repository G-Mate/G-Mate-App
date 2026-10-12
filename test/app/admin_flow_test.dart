import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/routes.dart';
import 'package:g_mate/features/admin/presentation/admin_pin_page.dart';
import 'package:g_mate/features/home/presentation/home_page.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('홈 남색 패널을 길게 누르고 PIN을 넣으면 장소 관리로 간다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.home));
    await tester.pump();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('무엇을\n도와드릴까요?')),
    );
    await tester.pump(HomePage.adminHoldDuration);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byType(AdminPinPage), findsOneWidget);

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('0'));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('장소 관리'), findsOneWidget);
    expect(find.text('로봇에 저장됨'), findsNWidgets(2));
  });

  testWidgets('홈 남색 패널을 짧게 누르면 아무 일도 없다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.home));
    await tester.pump();

    await tester.longPress(find.text('무엇을\n도와드릴까요?'));
    await tester.pumpAndSettle();
    expect(find.byType(AdminPinPage), findsNothing);
  });
}
