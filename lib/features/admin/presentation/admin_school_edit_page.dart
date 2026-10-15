import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import 'bloc/admin_school_edit_cubit.dart';
import 'bloc/admin_school_edit_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 학교 개요 편집. 왼쪽에서 사진과 제목을, 오른쪽에서 소개 문서를
/// 글 쓰듯 고친다.
class AdminSchoolEditPage extends StatelessWidget {
  const AdminSchoolEditPage({super.key});

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
              // 왼쪽: 화면 왼쪽에 걸리는 사진과 문서 제목
              Expanded(
                flex: 4,
                child: AdminSection(
                  title: '사진과 제목',
                  child: ListView(
                    children: [
                      AdminPhotoField(
                        image: switch (info.imagePath) {
                          final path? => FileImage(File(path)),
                          null => null,
                        },
                        placeholder: const GmPlaceArt(icon: GmIcons.school),
                        hint: '학교 개요 왼쪽에 걸려 있어요',
                        onPick: cubit.pickImage,
                        onRemove: cubit.removeImage,
                      ),
                      AdminField(
                        label: '제목',
                        child: TextFormField(
                          initialValue: info.name,
                          onChanged: cubit.changeName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // 오른쪽: 문서 본문
              Expanded(
                flex: 6,
                child: AdminSection(
                  title: '문서',
                  trailing: Text(
                    "'# '은 소제목, '- '는 목록, 빈 줄은 문단 나눔",
                    style: text.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  child: TextFormField(
                    initialValue: info.document,
                    expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    style: text.bodyMedium,
                    onChanged: cubit.changeDocument,
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
