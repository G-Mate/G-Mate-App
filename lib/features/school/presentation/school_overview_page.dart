import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../../guide/presentation/widgets/keep_all_text.dart';
import '../domain/school_info.dart';
import 'bloc/school_overview_cubit.dart';

/// 학교 개요. 웹 문서처럼 위에서 아래로 읽는다: 학교 사진, 소개 글,
/// 단락(소제목·본문), 맨 끝에 층별 안내. 층별 안내의 장소를 누르면 그곳의
/// 장소 확인(길 찾기)으로 간다.
class SchoolOverviewPage extends StatelessWidget {
  const SchoolOverviewPage({super.key});

  /// 글이 너무 길게 늘어지지 않도록 문서 폭을 묶는다.
  static const _documentWidth = 960.0;
  static const _photoAspectRatio = 21 / 9;

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
        final text = context.textStyles;
        final semantic = context.appColors;
        final photo = info.imagePath;

        return GmScaffold(
          eyebrow: '학교 개요',
          title: info.name,
          onBack: () => context.go(AppRoutes.home),
          body: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _documentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (photo != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: AspectRatio(
                          aspectRatio: _photoAspectRatio,
                          child: Image(
                            image: FileImage(File(photo)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                    _Paragraphs(info.intro, style: text.headlineSmall),
                    for (final section in info.sections)
                      _Section(section: section),
                    const SizedBox(height: AppSpacing.xxl),
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
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 단락 하나: 소제목과 본문.
class _Section extends StatelessWidget {
  const _Section({required this.section});

  final SchoolSection section;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (section.title.isNotEmpty) ...[
            Text(section.title, style: text.titleLarge),
            const SizedBox(height: AppSpacing.sm),
          ],
          _Paragraphs(
            section.body,
            style: text.bodyLarge?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 줄을 바꾼 자리에서 줄을 바꾸고, 한 줄 안에서는 단어 단위로만 줄바꿈한다.
class _Paragraphs extends StatelessWidget {
  const _Paragraphs(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in text.split('\n'))
          if (line.trim().isNotEmpty) KeepAllText(line.trim(), style: style),
      ],
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
