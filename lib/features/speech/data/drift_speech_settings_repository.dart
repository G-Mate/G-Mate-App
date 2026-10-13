import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/speech_settings.dart';
import '../domain/speech_settings_repository.dart';

/// 로컬 DB(drift)에 두는 음성 설정 저장소. 저장한 적이 없으면 기본값이다.
class DriftSpeechSettingsRepository implements SpeechSettingsRepository {
  DriftSpeechSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SpeechSettings> load() async {
    final query = _db.select(_db.speechSettingsTable)
      ..where((t) => t.id.equals(AppDatabase.singleRowId));
    final row = await query.getSingleOrNull();
    if (row == null) return const SpeechSettings();
    return SpeechSettings(
      gender: VoiceGender.values.asNameMap()[row.gender] ?? VoiceGender.female,
      speed: row.speed,
      pitch: row.pitch,
      volume: row.volume,
    );
  }

  @override
  Future<void> save(SpeechSettings settings) => _db
      .into(_db.speechSettingsTable)
      .insertOnConflictUpdate(
        SpeechSettingsTableCompanion.insert(
          id: const Value(AppDatabase.singleRowId),
          gender: settings.gender.name,
          speed: settings.speed,
          pitch: settings.pitch,
          volume: settings.volume,
        ),
      );
}
