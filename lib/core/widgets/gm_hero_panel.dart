import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'gm_back_button.dart';
import 'gm_background.dart';

/// 화면 한쪽을 채우는 남색 패널. 홈(대기), 도착 안내처럼 화면의 주제를
/// 크게 보여 줄 때 쓴다.
///
/// 위에서부터 작은 머리말 → 큰 제목 → 부제, 맨 아래에 [footer]를 둔다.
/// 제목이 두 줄이면 첫 줄은 가늘고 옅게, 둘째 줄부터는 굵게 그려 대비를 준다.
class GmHeroPanel extends StatelessWidget {
  const GmHeroPanel({
    super.key,
    required this.title,
    this.overline,
    this.subtitle,
    this.footer,
    this.top,
  });

  final String title;

  /// 제목 위 작은 글자 (예: 학교 이름). 앞에 짧은 파랑 선이 붙는다.
  final String? overline;
  final String? subtitle;

  /// 패널 맨 아래에 둘 위젯 (예: 로봇 상태 표시).
  final Widget? footer;

  /// 패널 맨 위에 둘 위젯. 없으면 G-MATE 글자를 보여 준다
  /// (예: [GmHeroBackButton]).
  final Widget? top;

  static const _panelAlpha = 0.45;

  /// 두 줄 제목의 첫 줄 진하기.
  static const _leadAlpha = 0.72;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final lines = title.split('\n');
    final display = text.displayMedium?.copyWith(color: Colors.white);

    return DecoratedBox(
      // 바탕 위에 한 톤 어두운 반투명 남색을 깔아 화면을 둘로 나눈다.
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: _panelAlpha),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  top ??
                      Text(
                        'G-MATE',
                        style: text.labelSmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                  const Spacer(),
                  if (overline != null) ...[
                    GmOverline(overline!),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Text.rich(
                    TextSpan(
                      children: [
                        if (lines.length > 1)
                          TextSpan(
                            text: '${lines.first}\n',
                            style: display?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: _leadAlpha),
                            ),
                          ),
                        TextSpan(
                          text: lines.skip(lines.length > 1 ? 1 : 0).join('\n'),
                          style: display?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      subtitle!,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.onNavyMuted,
                      ),
                    ),
                  ],
                  const Spacer(),
                  ?footer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 짧은 파랑 선 + 작은 글자로 된 머리말 (예: '— 3층 · 교실').
class GmOverline extends StatelessWidget {
  const GmOverline(this.label, {super.key, this.color});

  final String label;

  /// 글자색. 없으면 남색 면 위 보조 글자색.
  final Color? color;

  static const _ruleWidth = 24.0;
  static const _ruleHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _ruleWidth,
          height: _ruleHeight,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color ?? AppColors.onNavyMuted,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}

/// 남색 패널 위에 두는 뒤로 가기 버튼. 모든 화면이 [GmBackButton] 하나를 쓴다.
class GmHeroBackButton extends StatelessWidget {
  const GmHeroBackButton({super.key, required this.onPressed, this.label});

  final VoidCallback onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) =>
      GmBackButton(onPressed: onPressed, label: label ?? '뒤로');
}

/// 왼쪽 남색 패널 + 오른쪽 본문으로 나뉜 화면 틀.
///
/// 홈, 장소 확인, 도착 화면처럼 화면의 주제를 크게 보여 줄 때 쓴다.
class GmSplitLayout extends StatelessWidget {
  const GmSplitLayout({
    super.key,
    required this.hero,
    required this.child,
    this.heroFlex = 5,
    this.childFlex = 7,
  });

  final Widget hero;
  final Widget child;
  final int heroFlex;
  final int childFlex;

  @override
  Widget build(BuildContext context) {
    return GmBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: heroFlex, child: hero),
            Expanded(
              flex: childFlex,
              child: SafeArea(
                left: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
