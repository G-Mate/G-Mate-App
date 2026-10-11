import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/design_system.dart';
import 'package:g_mate/features/design_gallery/presentation/design_gallery_page.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('GmTheme', () {
    test('브랜드 색과 의미 색 확장을 담는다', () {
      final theme = AppTheme.light();
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.extension<AppSemanticColors>(), AppSemanticColors.light);
    });

    test('본문 글자는 키오스크 기준 22sp 이상이다', () {
      final text = AppTheme.light().textTheme;
      expect(text.bodyMedium!.fontSize, greaterThanOrEqualTo(22));
      expect(text.labelLarge!.fontSize, greaterThanOrEqualTo(24));
    });
  });

  group('GmButton', () {
    testWidgets('크기별 높이가 토큰과 같다', (tester) async {
      for (final (size, height) in [
        (GmButtonSize.large, AppSize.buttonLarge),
        (GmButtonSize.medium, AppSize.buttonMedium),
        (GmButtonSize.small, AppSize.buttonSmall),
      ]) {
        await tester.pumpWidget(
          _wrap(GmButton(label: '안내 시작', size: size, onPressed: () {})),
        );
        expect(tester.getSize(find.byType(FilledButton)).height, height);
      }
    });

    testWidgets('누르면 콜백이 불리고, loading이면 눌리지 않는다', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(GmButton(label: '다음', onPressed: () => taps++)),
      );
      await tester.tap(find.byType(GmButton));
      expect(taps, 1);

      await tester.pumpWidget(
        _wrap(GmButton(label: '다음', loading: true, onPressed: () => taps++)),
      );
      await tester.tap(find.byType(GmButton));
      expect(taps, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('GmChoiceChip 터치 영역은 64dp 이상이다', (tester) async {
    await tester.pumpWidget(
      _wrap(GmChoiceChip(label: '교실', selected: false, onSelected: (_) {})),
    );
    expect(
      tester.getSize(find.byType(GmChoiceChip)).height,
      greaterThanOrEqualTo(AppSize.touchTargetMin),
    );
  });

  testWidgets('미리보기 화면이 가로 태블릿 크기에서 넘침 없이 그려진다', (tester) async {
    tester.view.physicalSize = const Size(1920, 1200);
    tester.view.devicePixelRatio = 1.5;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const DesignGalleryPage()),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('디자인 시스템'), findsOneWidget);
  });
}
