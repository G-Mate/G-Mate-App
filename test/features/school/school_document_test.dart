import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/theme/app_theme.dart';
import 'package:g_mate/features/school/presentation/widgets/school_document.dart';

void main() {
  testWidgets('소제목, 목록, 본문을 나눠 그린다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: SchoolDocument('첫 문단\n\n# 소제목\n- 하나\n- 둘')),
      ),
    );

    expect(find.text('소제목'), findsOneWidget);
    expect(find.text('# 소제목'), findsNothing);
    expect(find.text('•'), findsNWidgets(2));
    expect(find.bySemanticsLabel('하나'), findsOneWidget);
    expect(find.bySemanticsLabel('첫 문단'), findsOneWidget);
  });
}
