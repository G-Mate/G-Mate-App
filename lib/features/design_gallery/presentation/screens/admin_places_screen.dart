import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 관리 모드 - 장소 관리.
class AdminPlacesScreen extends StatelessWidget {
  const AdminPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textStyles;
    final semantic = context.appColors;

    return GmScaffold(
      eyebrow: '관리 모드',
      title: '장소 관리',
      onBack: () => Navigator.of(context).maybePop(),
      actions: [
        GmButton(
          label: '현재 위치 저장',
          icon: Icons.add_location_alt_outlined,
          onPressed: () {},
        ),
      ],
      body: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: ListView.separated(
          itemCount: samplePlaces.length,
          separatorBuilder: (_, _) =>
              const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
          itemBuilder: (context, i) {
            final p = samplePlaces[i];
            // 시안용: 마지막 장소는 temi에 아직 저장되지 않은 상태로 보여 준다.
            final synced = i != samplePlaces.length - 1;
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(p.icon, size: AppSize.iconMd, color: colors.primary),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: text.titleMedium),
                        Text(
                          '${p.meta} · ${p.key}',
                          style: text.bodySmall?.copyWith(
                            color: semantic.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GmStatusIndicator(
                    label: synced ? '로봇에 저장됨' : '로봇에 없음',
                    type: synced ? GmStatusType.success : GmStatusType.warning,
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  GmButton(
                    label: '미리 듣기',
                    size: GmButtonSize.small,
                    variant: GmButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GmButton(
                    label: '이동 테스트',
                    size: GmButtonSize.small,
                    variant: GmButtonVariant.outline,
                    onPressed: synced ? () {} : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
