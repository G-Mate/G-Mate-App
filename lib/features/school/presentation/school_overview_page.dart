import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../data/school_page_content.dart';
import 'widgets/school_page_view.dart';

/// 학교 개요. 광주소프트웨어마이스터고등학교를 소개하는 웹 페이지를 위아래로
/// 넘겨 읽는다. 내용은 앱에 고정해 둔다([schoolPageBlocks]).
class SchoolOverviewPage extends StatelessWidget {
  const SchoolOverviewPage({super.key});

  /// 글이 너무 길게 늘어지지 않도록 페이지 폭을 묶는다.
  static const _pageWidth = 1040.0;

  @override
  Widget build(BuildContext context) {
    return GmScaffold(
      eyebrow: '우리 학교',
      title: '학교 개요',
      onBack: () => context.go(AppRoutes.home),
      // 옆으로 넘기는 링크 줄이 화면 끝까지 펼쳐지도록 여백은 페이지가 직접 둔다.
      padded: false,
      body: const SchoolPageView(
        blocks: schoolPageBlocks,
        credit: schoolPageCredit,
        maxContentWidth: _pageWidth,
      ),
    );
  }
}
