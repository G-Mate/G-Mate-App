import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 길 찾기 - 장소 확인.
class PlaceConfirmScreen extends StatelessWidget {
  const PlaceConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final place = samplePlaces.first;
    final text = context.textStyles;
    final colors = context.colors;

    return GmSplitLayout(
      hero: GmHeroPanel(
        top: GmHeroBackButton(
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        overline: place.meta,
        title: place.name,
        subtitle: '이곳으로 안내할까요?',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: ColoredBox(
                color: colors.surface,
                child: Icon(
                  place.icon,
                  size: 160,
                  color: colors.primary.withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(sampleDescription, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: GmButton(
                  label: '다른 곳 고르기',
                  variant: GmButtonVariant.outline,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: GmButton(
                  label: '안내 시작',
                  icon: Icons.arrow_forward_rounded,
                  size: GmButtonSize.large,
                  expanded: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
