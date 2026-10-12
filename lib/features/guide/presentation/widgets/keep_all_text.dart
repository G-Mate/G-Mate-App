import 'package:flutter/widgets.dart';

/// 한국어 문장을 단어(띄어쓰기) 단위로만 줄바꿈한다.
///
/// Flutter 기본 줄바꿈은 글자 단위라 '교실입니/다.'처럼 단어 중간이 끊긴다.
class KeepAllText extends StatelessWidget {
  const KeepAllText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      excludeSemantics: true,
      child: Wrap(
        children: [
          for (final word in text.split(' ')) Text('$word ', style: style),
        ],
      ),
    );
  }
}
