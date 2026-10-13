import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/school_overview_cubit.dart';

/// 학교 개요. 왼쪽 남색 패널에 학교 소개와 숫자, 오른쪽에 학교 사진과
/// 층별 안내를 둔다. 층별 안내의 장소를 누르면 그곳의 장소 확인(길 찾기)으로 간다.
class SchoolOverviewPage extends StatelessWidget {
  const SchoolOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolOverviewCubit, SchoolOverviewState>(
      builder: (context, state) {
        final info = state.info;
        if (state.isLoading || info == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final semantic = context.appColors;
        final text = context.textStyles;

        return GmSplitLayout(
          hero: GmHeroPanel(
            top: GmHeroBackButton(onPressed: () => context.go(AppRoutes.home)),
            overline: info.name,
            title: '우리 학교를\n소개할게요',
            subtitle: info.intro,
            footer: GmStatRow(
              stats: [
                for (final s in info.stats)
                  GmStat(value: s.value, label: s.label),
                GmStat(value: '${state.placeCount}', label: '안내 장소'),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: switch (info.imagePath) {
                    final path? => Image(
                      image: FileImage(File(path)),
                      fit: BoxFit.cover,
                    ),
                    null => const GmPlaceArt(icon: GmIcons.school),
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('층별 안내', style: text.titleLarge),
                  const Spacer(),
                  Text(
                    '장소를 누르면 길을 안내해요',
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final floor in state.floors) _FloorRow(floor: floor),
            ],
          ),
        );
      },
    );
  }
}

/// 층 하나: 왼쪽에 층 번호와 짧은 설명, 오른쪽에 그 층 장소 버튼.
class _FloorRow extends StatelessWidget {
  const _FloorRow({required this.floor});

  final FloorDirectory floor;

  static const _labelWidth = 136.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final semantic = context.appColors;
    final text = context.textStyles;
    final label = floor.label;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: _labelWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${floor.floor}층', style: text.headlineMedium),
                if (label != null)
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final p in floor.places)
                  GmButton(
                    label: p.name,
                    variant: GmButtonVariant.outline,
                    onPressed: () =>
                        context.push(AppRoutes.placeConfirm(p.key)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
