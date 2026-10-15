import 'dart:io';

import 'package:drift/drift.dart'
    show OpeningDetails, QueryExecutor, QueryExecutorUser, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/app/database_seed.dart';
import 'package:g_mate/core/database/app_database.dart';
import 'package:g_mate/features/place/data/drift_place_repository.dart';
import 'package:g_mate/features/place/data/seed_places.dart';
import 'package:g_mate/features/place/domain/place.dart';
import 'package:g_mate/features/school/data/drift_school_info_repository.dart';
import 'package:g_mate/features/school/data/seed_school_info.dart';
import 'package:g_mate/features/speech/data/drift_speech_settings_repository.dart';
import 'package:g_mate/features/speech/domain/speech_settings.dart';
import 'package:g_mate/features/tour/data/drift_tour_repository.dart';
import 'package:g_mate/features/tour/data/seed_tours.dart';
import 'package:g_mate/features/tour/domain/tour.dart';

void main() {
  // 파일 DB 테스트는 메모리 DB와 따로 열고 닫으므로 여러 번 연다는 경고를 끈다.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory(), seed: seedDatabase);
  });

  tearDown(() => db.close());

  group('처음 만든 DB', () {
    test('기본 장소를 같은 순서로 담는다', () async {
      final places = await DriftPlaceRepository(db).getPlaces();
      expect(places, seedPlaces);
    });

    test('기본 투어 코스를 같은 순서로 담는다', () async {
      final tours = DriftTourRepository(db);
      expect(await tours.getTours(), seedTours);
      expect(await tours.getTour(seedTours.first.key), seedTours.first);
      expect(await tours.getTour('none'), isNull);
    });

    test('코스를 고치고 지울 수 있고, 새 코스는 목록 끝에 붙는다', () async {
      final tours = DriftTourRepository(db);
      final edited = seedTours.first.copyWith(
        name: '바꾼 코스',
        stops: const [TourStop(placeKey: 'library')],
      );
      await tours.saveTour(edited);
      const added = Tour(
        key: 'tour_new',
        name: '새 코스',
        description: '',
        duration: Duration(minutes: 5),
        stops: [TourStop(placeKey: 'science_lab')],
      );
      await tours.saveTour(added);
      await tours.deleteTour(seedTours[1].key);

      expect(await tours.getTours(), [edited, seedTours[2], added]);
    });

    test('기본 학교 소개를 담는다', () async {
      expect(
        await DriftSchoolInfoRepository(db).getSchoolInfo(),
        seedSchoolInfo,
      );
    });

    test('음성 설정은 저장 전에는 기본값이다', () async {
      expect(
        await DriftSpeechSettingsRepository(db).load(),
        const SpeechSettings(),
      );
    });
  });

  test('장소를 고치면 순서는 그대로, 내용은 바뀐다', () async {
    final repo = DriftPlaceRepository(db);
    final first = seedPlaces.first;
    final edited = first.copyWith(
      speech: first.speech.copyWith(descriptionLines: ['새 설명 한 줄']),
      lineInterval: const Duration(seconds: 12),
      imagePath: '/photos/science.jpg',
    );
    await repo.savePlace(edited);

    final places = await repo.getPlaces();
    expect(places.first, edited);
    expect(places.length, seedPlaces.length);
    expect(await repo.getPlace(first.key), edited);

    await repo.savePlace(edited.copyWith(clearImage: true));
    expect((await repo.getPlace(first.key))!.imagePath, isNull);
  });

  test('새 장소는 목록 끝에 붙는다', () async {
    final repo = DriftPlaceRepository(db);
    final created = Place.create(key: 'music_room', name: '음악실');
    await repo.savePlace(created);

    expect((await repo.getPlaces()).last, created);
    expect(await repo.getPlace('nowhere'), isNull);
  });

  test('음성 설정을 저장하고 다시 읽는다', () async {
    final repo = DriftSpeechSettingsRepository(db);
    const settings = SpeechSettings(
      gender: VoiceGender.male,
      speed: 1.5,
      pitch: -3,
      volume: 8,
    );
    await repo.save(settings);
    await repo.save(settings);
    expect(await repo.load(), settings);
  });

  test('파일 DB를 닫았다 다시 열면 고친 내용이 남고 기본 내용은 다시 넣지 않는다', () async {
    final dir = await Directory.systemTemp.createTemp('g_mate_db');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/g_mate.sqlite');
    var seeded = 0;
    AppDatabase open() => AppDatabase(
      NativeDatabase(file),
      seed: (db) async {
        seeded++;
        await seedDatabase(db);
      },
    );

    final first = open();
    final edited = seedPlaces.first.copyWith(name: '새 과학실');
    await DriftPlaceRepository(first).savePlace(edited);
    await first.close();

    final second = open();
    final places = await DriftPlaceRepository(second).getPlaces();
    await second.close();

    expect(seeded, 1);
    expect(places.first, edited);
    expect(places.length, seedPlaces.length);
  });

  test('스키마 1 DB를 열면 명령 기다리는 시간 칸을 기본값으로 더한다', () async {
    final dir = await Directory.systemTemp.createTemp('g_mate_db_v1');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/g_mate.sqlite');
    // 스키마 1의 음성 설정 표를 직접 만든다.
    final v1 = NativeDatabase(
      file,
      setup: (raw) {
        raw.execute(
          'CREATE TABLE speech_settings (id INTEGER NOT NULL PRIMARY KEY, '
          'gender TEXT NOT NULL, speed REAL NOT NULL, pitch INTEGER NOT NULL, '
          'volume INTEGER NOT NULL)',
        );
        raw.execute(
          "INSERT INTO speech_settings VALUES (0, 'male', 1.5, 2, 8)",
        );
        raw.execute('PRAGMA user_version = 1');
      },
    );
    await v1.ensureOpen(_NoUser());
    await v1.close();

    final upgraded = AppDatabase(NativeDatabase(file));
    final settings = await DriftSpeechSettingsRepository(upgraded).load();
    await upgraded.close();

    expect(settings.gender, VoiceGender.male);
    expect(settings.volume, 8);
    expect(settings.commandWait, SpeechSettings.defaultCommandWait);
  });

  test('명령 기다리는 시간을 저장하고 다시 읽는다', () async {
    final repo = DriftSpeechSettingsRepository(db);
    await repo.save(const SpeechSettings(commandWait: Duration(seconds: 7)));
    expect((await repo.load()).commandWait, const Duration(seconds: 7));
  });
}

/// 스키마 1 파일을 만들 때만 쓰는 빈 사용자.
class _NoUser extends QueryExecutorUser {
  @override
  int get schemaVersion => 1;

  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {}
}
