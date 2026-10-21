import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// 장소. 멘트·검색어처럼 목록인 값은 JSON 글자로 둔다.
@DataClassName('PlaceRow')
class Places extends Table {
  TextColumn get key => text()();
  TextColumn get name => text()();
  IntColumn get floor => integer()();
  TextColumn get category => text()();

  /// JSON 글자 목록.
  TextColumn get keywords => text()();

  /// `{"start", "arrival", "descriptionLines"}` JSON.
  TextColumn get speech => text()();
  TextColumn get originalSpeech => text()();
  IntColumn get lineIntervalMs => integer()();
  TextColumn get imagePath => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

/// 투어 코스. 들를 곳 목록은 JSON 글자로 둔다.
@DataClassName('TourRow')
class Tours extends Table {
  TextColumn get key => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get durationMinutes => integer()();

  /// `[{"placeKey", "lines"}]` JSON.
  TextColumn get stops => text()();
  TextColumn get imagePath => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

/// 음성 설정. 한 줄만 둔다 (id = [AppDatabase.singleRowId]).
@DataClassName('SpeechSettingsRow')
class SpeechSettingsTable extends Table {
  @override
  String get tableName => 'speech_settings';

  IntColumn get id => integer()();
  TextColumn get gender => text()();
  RealColumn get speed => real()();
  IntColumn get pitch => integer()();
  IntColumn get volume => integer()();

  /// 음성 명령을 안내하기 전에 기다리는 시간 (밀리초). 스키마 2에서 추가.
  IntColumn get commandWaitMs =>
      integer().withDefault(const Constant(defaultCommandWaitMs))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 음성 명령 기다리는 시간 기본값 (밀리초). `SpeechSettings.defaultCommandWait`와 같다.
const defaultCommandWaitMs = 3000;

/// 처음 DB를 만들 때 기본 내용을 넣는 함수.
typedef DatabaseSeeder = Future<void> Function(AppDatabase db);

/// 앱 로컬 DB(drift). 표 정의만 두고, 도메인 값으로 바꾸는 일은 기능별
/// `data/` 저장소가 맡는다.
@DriftDatabase(tables: [Places, Tours, SpeechSettingsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor, {this._seed});

  final DatabaseSeeder? _seed;

  /// 한 줄만 두는 표(음성 설정)의 id.
  static const singleRowId = 0;

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seed?.call(this);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(
          speechSettingsTable,
          speechSettingsTable.commandWaitMs,
        );
      }
      if (from < 3) {
        // 학교 개요는 앱에 고정한 소개 페이지로 바꿔서 학교 소개 표를 지운다.
        await m.deleteTable('school_infos');
      }
    },
  );
}
