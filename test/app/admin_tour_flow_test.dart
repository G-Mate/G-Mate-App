import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/di.dart';
import 'package:g_mate/app/routes.dart';
import 'package:g_mate/features/tour/data/seed_tours.dart';
import 'package:g_mate/features/tour/domain/tour_repository.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('관리 모드 메인에서 투어 관리로 가 새 코스를 만든다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.adminHome));
    await tester.pumpAndSettle();

    await tester.tap(find.text('투어 관리'));
    await tester.pumpAndSettle();
    expect(find.text(seedTours.first.name), findsOneWidget);

    await tester.tap(find.text('코스 추가'));
    await tester.pumpAndSettle();
    expect(find.text('새 코스'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '도서관 코스');
    await tester.tap(find.text('도서관'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(find.text('투어 관리'), findsOneWidget);
    expect(find.text('도서관 코스'), findsOneWidget);
    final tours = await getIt<TourRepository>().getTours();
    expect(tours.last.name, '도서관 코스');
  });

  testWidgets('삭제를 확인하면 코스가 목록에서 사라진다', (tester) async {
    useTabletView(tester);
    await registerTestDependencies();
    await tester.pumpWidget(testApp(AppRoutes.adminTours));
    await tester.pumpAndSettle();

    await tester.tap(find.text('삭제').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('지우기'));
    await tester.pumpAndSettle();

    expect(find.text(seedTours.first.name), findsNothing);
    expect(await getIt<TourRepository>().getTours(), hasLength(2));
  });
}
