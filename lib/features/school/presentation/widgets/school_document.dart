import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import '../../../guide/presentation/widgets/keep_all_text.dart';

/// 학교 개요 문서를 그린다.
///
/// `# `로 시작하는 줄은 소제목, `- `로 시작하는 줄은 목록, 빈 줄은 문단 사이
/// 여백, 나머지 줄은 본문이다. 한국어는 단어 단위로만 줄바꿈한다.
class SchoolDocument extends StatelessWidget {
  const SchoolDocument(this.document, {super.key});

  final String document;

  static const _headingPrefix = '# ';
  static const _bulletPrefix = '- ';
  static const _bullet = '•';
  static const _bulletWidth = 28.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final body = text.bodyLarge?.copyWith(
      color: context.appColors.textSecondary,
    );
    final children = <Widget>[];

    for (final raw in document.trim().split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) {
        children.add(const SizedBox(height: AppSpacing.md));
      } else if (line.startsWith(_headingPrefix)) {
        children.addAll([
          if (children.isNotEmpty) const SizedBox(height: AppSpacing.lg),
          Text(
            line.substring(_headingPrefix.length).trim(),
            style: text.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
        ]);
      } else if (line.startsWith(_bulletPrefix)) {
        children.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _bulletWidth,
                child: Text(_bullet, style: body),
              ),
              Expanded(
                child: KeepAllText(
                  line.substring(_bulletPrefix.length).trim(),
                  style: body,
                ),
              ),
            ],
          ),
        );
      } else {
        children.add(KeepAllText(line, style: body));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
