import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// 관리 모드처럼 가까이서 조작하는 화면에 쓰는 촘촘한 테마.
///
/// 글자와 입력 칸, 칩을 한 단계 줄인다. 안내 화면(멀리서 보는 화면)에는 쓰지 않는다.
class GmDenseTheme extends StatelessWidget {
  const GmDenseTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(data: AppTheme.dense(Theme.of(context)), child: child);
  }
}
