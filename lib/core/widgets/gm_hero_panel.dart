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
  });

  final String title;

  /// 제목 위 작은 글자 (예: 학교 이름).
  final String? overline;
  final String? subtitle;

  /// 패널 맨 아래에 둘 위젯 (예: 로봇 상태 표시).
  final Widget? footer;

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
