import 'speech_settings.dart';

abstract interface class SpeechSettingsRepository {
  Future<SpeechSettings> load();

  Future<void> save(SpeechSettings settings);
}
