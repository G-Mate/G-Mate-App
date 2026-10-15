import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';

/// 관리 모드 메인. 설정 앱처럼 묶음별 항목 목록을 두고, 누르면 세부 화면으로 간다.
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  /// 묶음 이름과 그 안의 항목.
  static const groups = [
    (
      title: '안내 내용',
      items: [
        (
          icon: Icons.place_outlined,
          title: '장소 관리',
          description: '장소 정보와 안내 멘트, 로봇에 저장한 위치',
          route: AppRoutes.adminPlaces,
        ),
        (
          icon: Icons.flag_outlined,
          title: '투어 관리',
          description: '투어 코스와 들르는 순서',
          route: AppRoutes.adminTours,
        ),
      ],
    ),
    (
      title: '로봇',
      items: [
        (
          icon: Icons.record_voice_over_outlined,
          title: '음성 설정',
          description: '목소리, 말하기 속도, 높낮이, 음량',
          route: AppRoutes.adminTts,
        ),
      ],
    ),
    (
      title: '보안',
      items: [
        (
          icon: Icons.password_rounded,
          title: 'PIN 변경',
          description: '관리 모드에 들어가는 PIN',
          route: AppRoutes.adminPinChange,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    return GmScaffold(
      eyebrow: '관리 모드',
      title: '설정',
      onBack: () => context.go(AppRoutes.home),
      body: ListView(
        children: [
          for (final (i, group) in groups.indexed) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            _GroupLabel(group.title),
            const SizedBox(height: AppSpacing.xs),
            Material(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final (j, item) in group.items.indexed) ...[
                    if (j > 0)
                      const Divider(
                        indent: AppSpacing.lg,
                        endIndent: AppSpacing.lg,
                      ),
                    _SettingRow(
                      icon: item.icon,
                      title: item.title,
                      description: item.description,
                      onTap: () => context.push(item.route),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 묶음 이름. 목록 카드 위에 작게 둔다.
class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: AppSpacing.lg),
    child: Text(
      text,
      style: context.textStyles.labelSmall?.copyWith(
        color: context.appColors.textSecondary,
      ),
    ),
  );
}

/// 설정 한 줄: 아이콘 칸, 이름·설명, 오른쪽 화살표.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  static const _iconBox = 48.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final semantic = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: _iconBox,
              height: _iconBox,
              decoration: BoxDecoration(
                color: colors.primary.withValues(
                  alpha: GmIcon.defaultFillOpacity,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: AppSize.iconSm, color: colors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.titleMedium),
                  Text(
                    description,
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: AppSize.iconMd,
              color: semantic.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
