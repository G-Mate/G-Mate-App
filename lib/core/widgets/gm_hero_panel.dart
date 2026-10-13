import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 화면 한쪽을 채우는 남색 패널. 홈(대기), 도착 안내처럼 화면의 주제를
/// 크게 보여 줄 때 쓴다.
///
/// 위에서부터 작은 머리말 → 큰 제목 → 부제, 맨 아래에 [footer]를 둔다.
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

  /// 제목 위 작은 글자 (예: 학교 이름).
  final String? overline;
  final String? subtitle;

  /// 패널 맨 아래에 둘 위젯 (예: 로봇 상태 표시).
  final Widget? footer;

  /// 패널 맨 위에 둘 위젯. 없으면 [GmBrandMark]를 보여 준다
  /// (예: [GmHeroBackButton]).
  final Widget? top;

  /// 오른쪽 위에 번지는 파랑 빛의 지름과 진하기.
  static const _glowSize = 640.0;
  static const _glowAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyLight, AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // 장식은 이 은은한 빛 하나뿐이다. 남색 면에 깊이를 준다.
          Positioned(
            top: -_glowSize / 2,
            right: -_glowSize / 2,
            child: IgnorePointer(
              child: Container(
                width: _glowSize,
                height: _glowSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: _glowAlpha),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  top ?? const GmBrandMark(),
                  const Spacer(),
                  if (overline != null) ...[
                    Text(
                      overline!,
                      style: text.labelSmall?.copyWith(
                        color: AppColors.onNavyMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Text(
                    title,
                    style: text.displaySmall?.copyWith(color: Colors.white),
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

/// 남색 패널 맨 위의 G-MATE 표시 (파랑 사각 배지 + 글자).
class GmBrandMark extends StatelessWidget {
  const GmBrandMark({super.key});

  static const _badgeSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _badgeSize,
          height: _badgeSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            'G',
            style: text.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'G-MATE',
          style: text.labelSmall?.copyWith(
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

/// 남색 패널 위에 두는 알약 모양 뒤로 가기 버튼 (흰 아이콘 + 글자).
class GmHeroBackButton extends StatelessWidget {
  const GmHeroBackButton({super.key, required this.onPressed, this.label});

  final VoidCallback onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.onNavySurface,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.lg, 0),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: AppSize.iconMd),
      label: Text(label ?? '뒤로'),
    );
  }
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
    return Scaffold(
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
    );
  }
}
