import 'package:flutter/widgets.dart';

/// 한국어 문장을 단어(띄어쓰기) 단위로만 줄바꿈한다.
///
/// Flutter 기본 줄바꿈은 글자 단위라 '교실입니/다.'처럼 단어 중간이 끊긴다.
class KeepAllText extends StatelessWidget {
  const KeepAllText(
    this.text, {
    super.key,
    this.style,
    this.alignment = WrapAlignment.start,
  });

  final String text;
  final TextStyle? style;

  /// 줄 안에서 단어를 어느 쪽으로 붙일지.
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      excludeSemantics: true,
      child: Wrap(
        alignment: alignment,
        children: [
          for (final word in text.split(' ')) Text('$word ', style: style),
        ],
      ),
    );
  }
}
