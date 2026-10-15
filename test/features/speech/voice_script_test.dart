import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/place/data/seed_places.dart';
import 'package:g_mate/features/speech/domain/voice_script.dart';
import 'package:g_mate/features/speech/presentation/voice_scripts.dart';

void main() {
  test('띄어쓰기와 문장 부호가 달라도 명령을 알아듣는다', () {
    final script = VoiceScripts.placeConfirm(seedPlaces.first);
    expect(script.match('안내시작')?.id, VoiceScripts.startCommand);
    expect(script.match('안내 시작해 줘!')?.id, VoiceScripts.startCommand);
    expect(script.match('음 취소할게요.')?.id, VoiceScripts.cancelCommand);
    expect(script.match('배고파'), isNull);
    expect(script.match('   '), isNull);
  });

  test('장소 이름이나 검색어를 말하면 그 장소를 고른다', () {
    final script = VoiceScripts.placeSelect(seedPlaces);
    expect(script.match('과학실로 가 줘')?.id, 'place:science_lab');
    expect(script.match('전산실')?.id, 'place:computer_lab');
    expect(script.match('장소 목록 알려 줘')?.id, VoiceScripts.listCommand);
  });

  test('여러 명령이 맞으면 가장 긴 말이 맞은 명령을 고른다', () {
    const script = VoiceScript(
      commands: [
        VoiceCommand('short', ['중지']),
        VoiceCommand('long', ['안내 중지']),
      ],
    );
    expect(script.match('안내 중지')?.id, 'long');
    expect(script.match('중지')?.id, 'short');
  });

  test('홈에서는 메뉴 이름으로 메뉴를 고른다', () {
    final script = VoiceScripts.home('길 찾기. 가고 싶은 곳까지 데려다 드려요');
    expect(script.match('길찾기')?.id, VoiceScripts.guideCommand);
    expect(script.match('학교 투어 할래')?.id, VoiceScripts.tourCommand);
    expect(script.match('학교 소개 해 줘')?.id, VoiceScripts.overviewCommand);
  });
}
