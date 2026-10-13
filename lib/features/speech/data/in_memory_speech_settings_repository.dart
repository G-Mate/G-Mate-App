import '../domain/speech_settings.dart';
import '../domain/speech_settings_repository.dart';

/// 메모리에만 두는 음성 설정 저장소. 테스트에서 쓴다.
class InMemorySpeechSettingsRepository implements SpeechSettingsRepository {
  SpeechSettings _settings = const SpeechSettings();

  @override
  Future<SpeechSettings> load() async => _settings;

  @override
  Future<void> save(SpeechSettings settings) async => _settings = settings;
}
