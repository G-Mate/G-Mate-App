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

/// 관리 모드 - 학교 개요 편집. 학교 개요 화면의 이름·소개 글·사진과
/// 남색 패널 아래 숫자, 층별 안내의 층 설명을 고친다.
class AdminSchoolEditPage extends StatelessWidget {
  const AdminSchoolEditPage({super.key});

  static const _introLines = 4;

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
              // 왼쪽: 남색 패널과 사진 칸에 보이는 내용
              Expanded(
                flex: 5,
                child: AdminSection(
                  title: '기본 정보',
                  child: ListView(
                    children: [
                      AdminPhotoField(
                        image: switch (info.imagePath) {
                          final path? => FileImage(File(path)),
                          null => null,
                        },
                        placeholder: const GmPlaceArt(icon: GmIcons.school),
                        hint: '학교 개요 오른쪽 큰 칸에 보여요',
                        onPick: cubit.pickImage,
                        onRemove: cubit.removeImage,
                      ),
                      AdminField(
                        label: '학교 이름',
                        child: TextFormField(
                          initialValue: info.name,
                          onChanged: cubit.changeName,
                        ),
                      ),
                      AdminField(
                        label: '소개 글',
                        hint: '줄을 바꾸면 화면에서도 그 자리에서 줄이 바뀌어요',
                        child: TextFormField(
                          initialValue: info.intro,
                          minLines: _introLines,
                          maxLines: _introLines,
                          style: text.bodyMedium,
                          onChanged: cubit.changeIntro,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 오른쪽: 숫자와 층 설명
              Expanded(
                flex: 5,
                child: AdminSection(
                  title: '숫자와 층 안내',
                  child: ListView(
                    children: [
                      _Header(
                        label: '숫자',
                        hint:
                            '남색 패널 아래에 크게 보여요. '
                            "'안내 장소' 수는 저절로 붙어요",
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      for (var i = 0; i < info.stats.length; i++)
                        _StatRow(
                          key: ValueKey('stat-${state.statIds[i]}'),
                          stat: info.stats[i],
                          onValue: (v) => cubit.changeStatValue(i, v),
                          onLabel: (v) => cubit.changeStatLabel(i, v),
                          onRemove: () => cubit.removeStat(i),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: state.canAddStat ? cubit.addStat : null,
                          icon: const Icon(
                            Icons.add_rounded,
                            size: AppSize.iconSm,
                          ),
                          label: Text(
                            state.canAddStat
                                ? '숫자 추가'
                                : '숫자는 ${SchoolInfo.maxStats}개까지 넣을 수 있어요',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _Header(
                        label: '층별 설명',
                        hint: '층별 안내에서 층 번호 아래에 보여요',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      for (final floor in AdminPlaceEditPage.floors)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
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
                                  initialValue: info.floorLabels[floor] ?? '',
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
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 묶음 라벨 + 도움말.
class _Header extends StatelessWidget {
  const _Header({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Row(
      children: [
        Text(label, style: text.labelSmall),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            hint,
            style: text.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// 숫자 한 줄: 값, 설명, [지우기].
class _StatRow extends StatelessWidget {
  const _StatRow({
    super.key,
    required this.stat,
    required this.onValue,
    required this.onLabel,
    required this.onRemove,
  });

  final SchoolStat stat;
  final ValueChanged<String> onValue;
  final ValueChanged<String> onLabel;
  final VoidCallback onRemove;

  static const _valueWidth = 160.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: _valueWidth,
            child: TextFormField(
              initialValue: stat.value,
              decoration: const InputDecoration(hintText: '값 (예: 2015)'),
              onChanged: onValue,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: TextFormField(
              initialValue: stat.label,
              decoration: const InputDecoration(hintText: '설명 (예: 개교)'),
              onChanged: onLabel,
            ),
          ),
          IconButton(
            tooltip: '이 숫자 지우기',
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
    );
  }
}
