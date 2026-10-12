import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/core/utils/korean.dart';

void main() {
  test('받침에 따라 로와 으로를 붙인다', () {
    expect(Korean.withRo('과학실'), '과학실로');
    expect(Korean.withRo('도서관'), '도서관으로');
    expect(Korean.withRo('강당'), '강당으로');
    expect(Korean.withRo('컴퓨터'), '컴퓨터로');
    expect(Korean.withRo('PC'), 'PC(으)로');
  });
}
