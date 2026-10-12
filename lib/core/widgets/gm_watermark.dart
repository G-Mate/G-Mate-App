import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 배경에 아주 크고 옅게 깔아 두는 장식 글자.
///
/// `Stack` 안에서 `Positioned`와 함께 쓰고, 읽히지 않도록 접근성 트리에서 뺀다.
class GmWatermark extends StatelessWidget {
  const GmWatermark(this.text, {super.key, this.fontSize = 240});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: IgnorePointer(
        child: Text(
          text,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            height: 1,
            letterSpacing: -fontSize * 0.04,
            color: AppColors.watermark,
          ),
        ),
      ),
    );
  }
}
