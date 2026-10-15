import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import 'bloc/admin_school_edit_cubit.dart';
import 'bloc/admin_school_edit_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 학교 개요 편집. 학교 개요 위에 보이는 만든 사람들과, 아래에
/// 띄우는 학교 홈페이지 주소를 고친다.
class AdminSchoolEditPage extends StatelessWidget {
  const AdminSchoolEditPage({super.key});

  static const _namesHint = '여러 명이면 쉼표로 나눠 적어요. 비우면 보이지 않아요';

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
              onPressed: state.isUrlValid ? cubit.save : null,
            ),
          ],
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AdminSection(
                  title: '만든 사람들',
                  child: ListView(
                    children: [
                      AdminField(
                        label: '팀 이름',
                        child: TextFormField(
                          initialValue: info.teamName,
                          onChanged: cubit.changeTeamName,
                        ),
                      ),
                      AdminField(
                        label: '개발자',
                        hint: _namesHint,
                        child: TextFormField(
                          initialValue: info.developer,
                          decoration: const InputDecoration(
                            hintText: '예: 홍길동, 김철수',
                          ),
                          onChanged: cubit.changeDeveloper,
                        ),
                      ),
                      AdminField(
                        label: '기획자',
                        hint: _namesHint,
                        child: TextFormField(
                          initialValue: info.planner,
                          decoration: const InputDecoration(hintText: '예: 이영희'),
                          onChanged: cubit.changePlanner,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AdminSection(
                  title: '학교 홈페이지',
                  child: ListView(
                    children: [
                      AdminField(
                        label: '주소',
                        hint: '학교 개요 아래에 이 페이지를 띄워요',
                        child: TextFormField(
                          initialValue: info.homepageUrl,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            errorText: state.isUrlValid
                                ? null
                                : 'https://로 시작하는 주소를 적어 주세요',
                          ),
                          onChanged: cubit.changeHomepageUrl,
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
