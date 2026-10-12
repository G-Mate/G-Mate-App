/// 한국어 조사 붙이기.
abstract final class Korean {
  static const _hangulStart = 0xAC00;
  static const _hangulEnd = 0xD7A3;
  static const _jongseongCount = 28;

  /// 'ㄹ' 받침 번호. '로'는 ㄹ 받침 뒤에서도 '로'를 쓴다 (교실로).
  static const _rieul = 8;

  /// [word] 뒤에 '로' 또는 '으로'를 붙인다. 예: 과학실로, 도서관으로, 강당으로.
  static String withRo(String word) {
    if (word.isEmpty) return word;
    final code = word.codeUnitAt(word.length - 1);
    if (code < _hangulStart || code > _hangulEnd) return '$word(으)로';
    final jong = (code - _hangulStart) % _jongseongCount;
    return jong == 0 || jong == _rieul ? '$word로' : '$word으로';
  }
}
