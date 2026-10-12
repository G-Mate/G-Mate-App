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

  /// 패널 맨 위에 둘 위젯. 없으면 G-MATE 글자를 보여 준다
  /// (예: [GmHeroBackButton]).
  final Widget? top;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyLight, AppColors.navy],
        ),
      ),
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
                    letterSpacing: 2,
                  ),
                ),
            const Spacer(),
            if (overline != null) ...[
              Text(
                overline!,
                style: text.bodySmall?.copyWith(color: AppColors.onNavyMuted),
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
                style: text.bodyMedium?.copyWith(color: AppColors.onNavyMuted),
              ),
            ],
            const Spacer(),
            ?footer,
          ],
        ),
      ),
    );
  }
}

/// 남색 패널 위에 두는 뒤로 가기 버튼 (흰 아이콘 + 글자).
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
