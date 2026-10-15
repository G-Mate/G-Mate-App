import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/school_overview_cubit.dart';
import 'widgets/school_page_view.dart';

/// 학교 개요. 관리 모드에서 블록으로 만든 페이지를 웹 페이지처럼 위아래로
/// 넘겨 읽는다.
class SchoolOverviewPage extends StatelessWidget {
  const SchoolOverviewPage({super.key});

  /// 글이 너무 길게 늘어지지 않도록 페이지 폭을 묶는다.
  static const _pageWidth = 1040.0;

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
          eyebrow: '우리 학교',
          title: '학교 개요',
          onBack: () => context.go(AppRoutes.home),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _pageWidth),
              child: SchoolPageView(info: info),
            ),
          ),
        );
      },
    );
  }
}
