import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/theme/app_theme.dart';
import 'package:g_mate/features/design_gallery/presentation/screens/design_screens.dart';

void main() {
  for (final screen in designScreens) {
    testWidgets('${screen.title} 시안이 가로 태블릿 크기에서 넘침 없이 그려진다', (tester) async {
      tester.view.physicalSize = const Size(1920, 1200);
      tester.view.devicePixelRatio = 1.5;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: screen.page),
      );
      // 이동 중 화면의 진행 표시는 계속 움직이므로 한 번만 그린다.
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });
  }
}
