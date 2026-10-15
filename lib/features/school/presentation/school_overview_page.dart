import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/school_overview_cubit.dart';
import 'widgets/school_homepage_view.dart';

/// 학교 개요. 위에 팀 이름과 개발자·기획자를 짧게 보여 주고, 아래에 학교
/// 홈페이지를 띄운다.
class SchoolOverviewPage extends StatefulWidget {
  const SchoolOverviewPage({super.key});

  @override
  State<SchoolOverviewPage> createState() => _SchoolOverviewPageState();
}

class _SchoolOverviewPageState extends State<SchoolOverviewPage> {
  /// [처음으로]를 누른 횟수. 늘면 홈페이지를 처음 주소로 다시 연다.
  int _reloadCount = 0;

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

        return GmScaffold(
          eyebrow: '만든 사람들',
          title: info.teamName,
          onBack: () => context.go(AppRoutes.home),
          actions: [
            if (info.developer.isNotEmpty)
              _Credit(role: '개발', names: info.developer),
            if (info.planner.isNotEmpty)
              _Credit(role: '기획', names: info.planner),
            GmButton(
              label: '처음으로',
              icon: Icons.home_outlined,
              variant: GmButtonVariant.outline,
              onPressed: () => setState(() => _reloadCount++),
            ),
          ],
          body: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: ColoredBox(
              color: context.colors.surface,
              child: SchoolHomepageView(
                url: info.homepageUrl,
                reloadCount: _reloadCount,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 머리줄 오른쪽의 역할과 이름. 한 줄에 '개발  홍길동, 김철수'처럼 둔다.
class _Credit extends StatelessWidget {
  const _Credit({required this.role, required this.names});

  final String role;
  final String names;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$role  ',
              style: text.bodySmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
            TextSpan(text: names, style: text.titleSmall),
          ],
        ),
      ),
    );
  }
}
