import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../school/domain/school_info.dart';
import 'admin_place_edit_page.dart';
import 'bloc/admin_school_edit_cubit.dart';
import 'bloc/admin_school_edit_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 학교 개요 편집. 왼쪽에서 문서 본문(이름, 소개 글, 단락)을,
/// 오른쪽에서 사진과 층별 안내의 층 설명을 고친다.
class AdminSchoolEditPage extends StatelessWidget {
  const AdminSchoolEditPage({super.key});

  static const _introLines = 3;

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    return BlocConsumer<AdminSchoolEditCubit, AdminSchoolEditState>(
      listenWhen: (prev, next) => !prev.isSaved && next.isSaved,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('학교 개요를 저장했어요')));
        context.pop();
      },
      builder: (context, state) {
        final info = state.info;
        if (state.isLoading || info == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final cubit = context.read<AdminSchoolEditCubit>();
        final text = context.textStyles;
        final semantic = context.appColors;

        return GmScaffold(
          eyebrow: '관리 모드',
          title: '학교 개요',
          onBack: () => context.pop(),
          actions: [
            GmButton(
              label: '취소',
              size: GmButtonSize.small,
              variant: GmButtonVariant.outline,
              onPressed: () => context.pop(),
            ),
            GmButton(
              label: '저장',
              icon: Icons.check_rounded,
              size: GmButtonSize.small,
              onPressed: info.name.trim().isEmpty ? null : cubit.save,
            ),
          ],
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽: 문서 본문. 학교 개요 화면에 이 순서대로 보인다.
              Expanded(
                flex: 6,
                child: AdminSection(
                  title: '본문',
                  trailing: Text(
                    '학교 개요에 이 순서대로 보여요',
                    style: text.bodySmall?.copyWith(
                      color: semantic.textSecondary,
                    ),
                  ),
                  child: ListView(
                    children: [
                      AdminField(
                        label: '학교 이름',
                        child: TextFormField(
                          initialValue: info.name,
                          onChanged: cubit.changeName,
                        ),
                      ),
                      AdminField(
                        label: '소개 글',
                        hint: '맨 위에 크게 보이는 짧은 글이에요',
                        child: TextFormField(
                          initialValue: info.intro,
                          minLines: _introLines,
                          maxLines: _introLines,
                          style: text.bodyMedium,
                          onChanged: cubit.changeIntro,
                        ),
                      ),
                      for (var i = 0; i < info.sections.length; i++)
                        _SectionField(
                          key: ValueKey('section-${state.sectionIds[i]}'),
                          section: info.sections[i],
                          onTitle: (v) => cubit.changeSectionTitle(i, v),
                          onBody: (v) => cubit.changeSectionBody(i, v),
                          onRemove: () => cubit.removeSection(i),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: cubit.addSection,
                          icon: const Icon(
                            Icons.add_rounded,
                            size: AppSize.iconSm,
                          ),
                          label: const Text('단락 추가'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 오른쪽: 사진과 층 설명
              Expanded(
                flex: 4,
                child: AdminSection(
                  title: '사진과 층 안내',
                  child: ListView(
                    children: [
                      AdminPhotoField(
                        image: switch (info.imagePath) {
                          final path? => FileImage(File(path)),
                          null => null,
                        },
                        placeholder: const GmPlaceArt(icon: GmIcons.school),
                        hint: '소개 글 위에 넓게 보여요. 없으면 글만 보여요',
                        onPick: cubit.pickImage,
                        onRemove: cubit.removeImage,
                      ),
                      AdminField(
                        label: '층별 설명',
                        hint: '층별 안내에서 층 번호 아래에 보여요',
                        child: Column(
                          children: [
                            for (final floor in AdminPlaceEditPage.floors)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.xs,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: AppSpacing.xxl,
                                      child: Text(
                                        '$floor층',
                                        style: text.labelSmall?.copyWith(
                                          color: semantic.textSecondary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue:
                                            info.floorLabels[floor] ?? '',
                                        decoration: const InputDecoration(
                                          hintText: '예: 교실·실습실',
                                        ),
                                        onChanged: (v) =>
                                            cubit.changeFloorLabel(floor, v),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 단락 하나: 소제목 + [지우기], 그 아래 본문.
class _SectionField extends StatelessWidget {
  const _SectionField({
    super.key,
    required this.section,
    required this.onTitle,
    required this.onBody,
    required this.onRemove,
  });

  final SchoolSection section;
  final ValueChanged<String> onTitle;
  final ValueChanged<String> onBody;
  final VoidCallback onRemove;

  static const _bodyLines = 4;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: section.title,
                  style: text.titleSmall,
                  decoration: const InputDecoration(
                    hintText: '소제목 (예: 한눈에 보기)',
                  ),
                  onChanged: onTitle,
                ),
              ),
              IconButton(
                tooltip: '이 단락 지우기',
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(AppSize.buttonSmall),
                ),
                onPressed: onRemove,
                icon: Icon(
                  Icons.close_rounded,
                  size: AppSize.iconSm,
                  color: context.appColors.textDisabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            initialValue: section.body,
            minLines: _bodyLines,
            maxLines: _bodyLines,
            style: text.bodyMedium,
            decoration: const InputDecoration(
              hintText: '본문. 줄을 바꾸면 화면에서도 줄이 바뀌어요',
            ),
            onChanged: onBody,
          ),
        ],
      ),
    );
  }
}
