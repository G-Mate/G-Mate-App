// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlacesTable extends Places with TableInfo<$PlacesTable, PlaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _floorMeta = const VerificationMeta('floor');
  @override
  late final GeneratedColumn<int> floor = GeneratedColumn<int>(
    'floor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keywordsMeta = const VerificationMeta(
    'keywords',
  );
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
    'keywords',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speechMeta = const VerificationMeta('speech');
  @override
  late final GeneratedColumn<String> speech = GeneratedColumn<String>(
    'speech',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalSpeechMeta = const VerificationMeta(
    'originalSpeech',
  );
  @override
  late final GeneratedColumn<String> originalSpeech = GeneratedColumn<String>(
    'original_speech',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineIntervalMsMeta = const VerificationMeta(
    'lineIntervalMs',
  );
  @override
  late final GeneratedColumn<int> lineIntervalMs = GeneratedColumn<int>(
    'line_interval_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    name,
    floor,
    category,
    keywords,
    speech,
    originalSpeech,
    lineIntervalMs,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('floor')) {
      context.handle(
        _floorMeta,
        floor.isAcceptableOrUnknown(data['floor']!, _floorMeta),
      );
    } else if (isInserting) {
      context.missing(_floorMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('keywords')) {
      context.handle(
        _keywordsMeta,
        keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordsMeta);
    }
    if (data.containsKey('speech')) {
      context.handle(
        _speechMeta,
        speech.isAcceptableOrUnknown(data['speech']!, _speechMeta),
      );
    } else if (isInserting) {
      context.missing(_speechMeta);
    }
    if (data.containsKey('original_speech')) {
      context.handle(
        _originalSpeechMeta,
        originalSpeech.isAcceptableOrUnknown(
          data['original_speech']!,
          _originalSpeechMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalSpeechMeta);
    }
    if (data.containsKey('line_interval_ms')) {
      context.handle(
        _lineIntervalMsMeta,
        lineIntervalMs.isAcceptableOrUnknown(
          data['line_interval_ms']!,
          _lineIntervalMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lineIntervalMsMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PlaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      floor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      keywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords'],
      )!,
      speech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speech'],
      )!,
      originalSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_speech'],
      )!,
      lineIntervalMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_interval_ms'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class PlaceRow extends DataClass implements Insertable<PlaceRow> {
  final String key;
  final String name;
  final int floor;
  final String category;

  /// JSON 글자 목록.
  final String keywords;

  /// `{"start", "arrival", "descriptionLines"}` JSON.
  final String speech;
  final String originalSpeech;
  final int lineIntervalMs;
  final String? imagePath;
  const PlaceRow({
    required this.key,
    required this.name,
    required this.floor,
    required this.category,
    required this.keywords,
    required this.speech,
    required this.originalSpeech,
    required this.lineIntervalMs,
    this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    map['floor'] = Variable<int>(floor);
    map['category'] = Variable<String>(category);
    map['keywords'] = Variable<String>(keywords);
    map['speech'] = Variable<String>(speech);
    map['original_speech'] = Variable<String>(originalSpeech);
    map['line_interval_ms'] = Variable<int>(lineIntervalMs);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      key: Value(key),
      name: Value(name),
      floor: Value(floor),
      category: Value(category),
      keywords: Value(keywords),
      speech: Value(speech),
      originalSpeech: Value(originalSpeech),
      lineIntervalMs: Value(lineIntervalMs),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory PlaceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceRow(
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      floor: serializer.fromJson<int>(json['floor']),
      category: serializer.fromJson<String>(json['category']),
      keywords: serializer.fromJson<String>(json['keywords']),
      speech: serializer.fromJson<String>(json['speech']),
      originalSpeech: serializer.fromJson<String>(json['originalSpeech']),
      lineIntervalMs: serializer.fromJson<int>(json['lineIntervalMs']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'floor': serializer.toJson<int>(floor),
      'category': serializer.toJson<String>(category),
      'keywords': serializer.toJson<String>(keywords),
      'speech': serializer.toJson<String>(speech),
      'originalSpeech': serializer.toJson<String>(originalSpeech),
      'lineIntervalMs': serializer.toJson<int>(lineIntervalMs),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  PlaceRow copyWith({
    String? key,
    String? name,
    int? floor,
    String? category,
    String? keywords,
    String? speech,
    String? originalSpeech,
    int? lineIntervalMs,
    Value<String?> imagePath = const Value.absent(),
  }) => PlaceRow(
    key: key ?? this.key,
    name: name ?? this.name,
    floor: floor ?? this.floor,
    category: category ?? this.category,
    keywords: keywords ?? this.keywords,
    speech: speech ?? this.speech,
    originalSpeech: originalSpeech ?? this.originalSpeech,
    lineIntervalMs: lineIntervalMs ?? this.lineIntervalMs,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  PlaceRow copyWithCompanion(PlacesCompanion data) {
    return PlaceRow(
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      floor: data.floor.present ? data.floor.value : this.floor,
      category: data.category.present ? data.category.value : this.category,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      speech: data.speech.present ? data.speech.value : this.speech,
      originalSpeech: data.originalSpeech.present
          ? data.originalSpeech.value
          : this.originalSpeech,
      lineIntervalMs: data.lineIntervalMs.present
          ? data.lineIntervalMs.value
          : this.lineIntervalMs,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceRow(')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('floor: $floor, ')
          ..write('category: $category, ')
          ..write('keywords: $keywords, ')
          ..write('speech: $speech, ')
          ..write('originalSpeech: $originalSpeech, ')
          ..write('lineIntervalMs: $lineIntervalMs, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    name,
    floor,
    category,
    keywords,
    speech,
    originalSpeech,
    lineIntervalMs,
    imagePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceRow &&
          other.key == this.key &&
          other.name == this.name &&
          other.floor == this.floor &&
          other.category == this.category &&
          other.keywords == this.keywords &&
          other.speech == this.speech &&
          other.originalSpeech == this.originalSpeech &&
          other.lineIntervalMs == this.lineIntervalMs &&
          other.imagePath == this.imagePath);
}

class PlacesCompanion extends UpdateCompanion<PlaceRow> {
  final Value<String> key;
  final Value<String> name;
  final Value<int> floor;
  final Value<String> category;
  final Value<String> keywords;
  final Value<String> speech;
  final Value<String> originalSpeech;
  final Value<int> lineIntervalMs;
  final Value<String?> imagePath;
  final Value<int> rowid;
  const PlacesCompanion({
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.floor = const Value.absent(),
    this.category = const Value.absent(),
    this.keywords = const Value.absent(),
    this.speech = const Value.absent(),
    this.originalSpeech = const Value.absent(),
    this.lineIntervalMs = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    required String key,
    required String name,
    required int floor,
    required String category,
    required String keywords,
    required String speech,
    required String originalSpeech,
    required int lineIntervalMs,
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       name = Value(name),
       floor = Value(floor),
       category = Value(category),
       keywords = Value(keywords),
       speech = Value(speech),
       originalSpeech = Value(originalSpeech),
       lineIntervalMs = Value(lineIntervalMs);
  static Insertable<PlaceRow> custom({
    Expression<String>? key,
    Expression<String>? name,
    Expression<int>? floor,
    Expression<String>? category,
    Expression<String>? keywords,
    Expression<String>? speech,
    Expression<String>? originalSpeech,
    Expression<int>? lineIntervalMs,
    Expression<String>? imagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (floor != null) 'floor': floor,
      if (category != null) 'category': category,
      if (keywords != null) 'keywords': keywords,
      if (speech != null) 'speech': speech,
      if (originalSpeech != null) 'original_speech': originalSpeech,
      if (lineIntervalMs != null) 'line_interval_ms': lineIntervalMs,
      if (imagePath != null) 'image_path': imagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith({
    Value<String>? key,
    Value<String>? name,
    Value<int>? floor,
    Value<String>? category,
    Value<String>? keywords,
    Value<String>? speech,
    Value<String>? originalSpeech,
    Value<int>? lineIntervalMs,
    Value<String?>? imagePath,
    Value<int>? rowid,
  }) {
    return PlacesCompanion(
      key: key ?? this.key,
      name: name ?? this.name,
      floor: floor ?? this.floor,
      category: category ?? this.category,
      keywords: keywords ?? this.keywords,
      speech: speech ?? this.speech,
      originalSpeech: originalSpeech ?? this.originalSpeech,
      lineIntervalMs: lineIntervalMs ?? this.lineIntervalMs,
      imagePath: imagePath ?? this.imagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (floor.present) {
      map['floor'] = Variable<int>(floor.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (speech.present) {
      map['speech'] = Variable<String>(speech.value);
    }
    if (originalSpeech.present) {
      map['original_speech'] = Variable<String>(originalSpeech.value);
    }
    if (lineIntervalMs.present) {
      map['line_interval_ms'] = Variable<int>(lineIntervalMs.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('floor: $floor, ')
          ..write('category: $category, ')
          ..write('keywords: $keywords, ')
          ..write('speech: $speech, ')
          ..write('originalSpeech: $originalSpeech, ')
          ..write('lineIntervalMs: $lineIntervalMs, ')
          ..write('imagePath: $imagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToursTable extends Tours with TableInfo<$ToursTable, TourRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stopsMeta = const VerificationMeta('stops');
  @override
  late final GeneratedColumn<String> stops = GeneratedColumn<String>(
    'stops',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    name,
    description,
    durationMinutes,
    stops,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tours';
  @override
  VerificationContext validateIntegrity(
    Insertable<TourRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('stops')) {
      context.handle(
        _stopsMeta,
        stops.isAcceptableOrUnknown(data['stops']!, _stopsMeta),
      );
    } else if (isInserting) {
      context.missing(_stopsMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  TourRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TourRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      stops: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stops'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
    );
  }

  @override
  $ToursTable createAlias(String alias) {
    return $ToursTable(attachedDatabase, alias);
  }
}

class TourRow extends DataClass implements Insertable<TourRow> {
  final String key;
  final String name;
  final String description;
  final int durationMinutes;

  /// `[{"placeKey", "lines"}]` JSON.
  final String stops;
  final String? imagePath;
  const TourRow({
    required this.key,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.stops,
    this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['stops'] = Variable<String>(stops);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  ToursCompanion toCompanion(bool nullToAbsent) {
    return ToursCompanion(
      key: Value(key),
      name: Value(name),
      description: Value(description),
      durationMinutes: Value(durationMinutes),
      stops: Value(stops),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory TourRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TourRow(
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      stops: serializer.fromJson<String>(json['stops']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'stops': serializer.toJson<String>(stops),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  TourRow copyWith({
    String? key,
    String? name,
    String? description,
    int? durationMinutes,
    String? stops,
    Value<String?> imagePath = const Value.absent(),
  }) => TourRow(
    key: key ?? this.key,
    name: name ?? this.name,
    description: description ?? this.description,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    stops: stops ?? this.stops,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  TourRow copyWithCompanion(ToursCompanion data) {
    return TourRow(
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      stops: data.stops.present ? data.stops.value : this.stops,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TourRow(')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('stops: $stops, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key, name, description, durationMinutes, stops, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TourRow &&
          other.key == this.key &&
          other.name == this.name &&
          other.description == this.description &&
          other.durationMinutes == this.durationMinutes &&
          other.stops == this.stops &&
          other.imagePath == this.imagePath);
}

class ToursCompanion extends UpdateCompanion<TourRow> {
  final Value<String> key;
  final Value<String> name;
  final Value<String> description;
  final Value<int> durationMinutes;
  final Value<String> stops;
  final Value<String?> imagePath;
  final Value<int> rowid;
  const ToursCompanion({
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.stops = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ToursCompanion.insert({
    required String key,
    required String name,
    required String description,
    required int durationMinutes,
    required String stops,
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       name = Value(name),
       description = Value(description),
       durationMinutes = Value(durationMinutes),
       stops = Value(stops);
  static Insertable<TourRow> custom({
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? durationMinutes,
    Expression<String>? stops,
    Expression<String>? imagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (stops != null) 'stops': stops,
      if (imagePath != null) 'image_path': imagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ToursCompanion copyWith({
    Value<String>? key,
    Value<String>? name,
    Value<String>? description,
    Value<int>? durationMinutes,
    Value<String>? stops,
    Value<String?>? imagePath,
    Value<int>? rowid,
  }) {
    return ToursCompanion(
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      stops: stops ?? this.stops,
      imagePath: imagePath ?? this.imagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (stops.present) {
      map['stops'] = Variable<String>(stops.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToursCompanion(')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('stops: $stops, ')
          ..write('imagePath: $imagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchoolInfosTable extends SchoolInfos
    with TableInfo<$SchoolInfosTable, SchoolInfoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teamNameMeta = const VerificationMeta(
    'teamName',
  );
  @override
  late final GeneratedColumn<String> teamName = GeneratedColumn<String>(
    'team_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _developerMeta = const VerificationMeta(
    'developer',
  );
  @override
  late final GeneratedColumn<String> developer = GeneratedColumn<String>(
    'developer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _plannerMeta = const VerificationMeta(
    'planner',
  );
  @override
  late final GeneratedColumn<String> planner = GeneratedColumn<String>(
    'planner',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _homepageUrlMeta = const VerificationMeta(
    'homepageUrl',
  );
  @override
  late final GeneratedColumn<String> homepageUrl = GeneratedColumn<String>(
    'homepage_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    teamName,
    developer,
    planner,
    homepageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'school_infos';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchoolInfoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('team_name')) {
      context.handle(
        _teamNameMeta,
        teamName.isAcceptableOrUnknown(data['team_name']!, _teamNameMeta),
      );
    }
    if (data.containsKey('developer')) {
      context.handle(
        _developerMeta,
        developer.isAcceptableOrUnknown(data['developer']!, _developerMeta),
      );
    }
    if (data.containsKey('planner')) {
      context.handle(
        _plannerMeta,
        planner.isAcceptableOrUnknown(data['planner']!, _plannerMeta),
      );
    }
    if (data.containsKey('homepage_url')) {
      context.handle(
        _homepageUrlMeta,
        homepageUrl.isAcceptableOrUnknown(
          data['homepage_url']!,
          _homepageUrlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchoolInfoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolInfoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      teamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_name'],
      )!,
      developer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}developer'],
      )!,
      planner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planner'],
      )!,
      homepageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}homepage_url'],
      )!,
    );
  }

  @override
  $SchoolInfosTable createAlias(String alias) {
    return $SchoolInfosTable(attachedDatabase, alias);
  }
}

class SchoolInfoRow extends DataClass implements Insertable<SchoolInfoRow> {
  final int id;
  final String teamName;
  final String developer;
  final String planner;
  final String homepageUrl;
  const SchoolInfoRow({
    required this.id,
    required this.teamName,
    required this.developer,
    required this.planner,
    required this.homepageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['team_name'] = Variable<String>(teamName);
    map['developer'] = Variable<String>(developer);
    map['planner'] = Variable<String>(planner);
    map['homepage_url'] = Variable<String>(homepageUrl);
    return map;
  }

  SchoolInfosCompanion toCompanion(bool nullToAbsent) {
    return SchoolInfosCompanion(
      id: Value(id),
      teamName: Value(teamName),
      developer: Value(developer),
      planner: Value(planner),
      homepageUrl: Value(homepageUrl),
    );
  }

  factory SchoolInfoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolInfoRow(
      id: serializer.fromJson<int>(json['id']),
      teamName: serializer.fromJson<String>(json['teamName']),
      developer: serializer.fromJson<String>(json['developer']),
      planner: serializer.fromJson<String>(json['planner']),
      homepageUrl: serializer.fromJson<String>(json['homepageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'teamName': serializer.toJson<String>(teamName),
      'developer': serializer.toJson<String>(developer),
      'planner': serializer.toJson<String>(planner),
      'homepageUrl': serializer.toJson<String>(homepageUrl),
    };
  }

  SchoolInfoRow copyWith({
    int? id,
    String? teamName,
    String? developer,
    String? planner,
    String? homepageUrl,
  }) => SchoolInfoRow(
    id: id ?? this.id,
    teamName: teamName ?? this.teamName,
    developer: developer ?? this.developer,
    planner: planner ?? this.planner,
    homepageUrl: homepageUrl ?? this.homepageUrl,
  );
  SchoolInfoRow copyWithCompanion(SchoolInfosCompanion data) {
    return SchoolInfoRow(
      id: data.id.present ? data.id.value : this.id,
      teamName: data.teamName.present ? data.teamName.value : this.teamName,
      developer: data.developer.present ? data.developer.value : this.developer,
      planner: data.planner.present ? data.planner.value : this.planner,
      homepageUrl: data.homepageUrl.present
          ? data.homepageUrl.value
          : this.homepageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolInfoRow(')
          ..write('id: $id, ')
          ..write('teamName: $teamName, ')
          ..write('developer: $developer, ')
          ..write('planner: $planner, ')
          ..write('homepageUrl: $homepageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, teamName, developer, planner, homepageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolInfoRow &&
          other.id == this.id &&
          other.teamName == this.teamName &&
          other.developer == this.developer &&
          other.planner == this.planner &&
          other.homepageUrl == this.homepageUrl);
}

class SchoolInfosCompanion extends UpdateCompanion<SchoolInfoRow> {
  final Value<int> id;
  final Value<String> teamName;
  final Value<String> developer;
  final Value<String> planner;
  final Value<String> homepageUrl;
  const SchoolInfosCompanion({
    this.id = const Value.absent(),
    this.teamName = const Value.absent(),
    this.developer = const Value.absent(),
    this.planner = const Value.absent(),
    this.homepageUrl = const Value.absent(),
  });
  SchoolInfosCompanion.insert({
    this.id = const Value.absent(),
    this.teamName = const Value.absent(),
    this.developer = const Value.absent(),
    this.planner = const Value.absent(),
    this.homepageUrl = const Value.absent(),
  });
  static Insertable<SchoolInfoRow> custom({
    Expression<int>? id,
    Expression<String>? teamName,
    Expression<String>? developer,
    Expression<String>? planner,
    Expression<String>? homepageUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teamName != null) 'team_name': teamName,
      if (developer != null) 'developer': developer,
      if (planner != null) 'planner': planner,
      if (homepageUrl != null) 'homepage_url': homepageUrl,
    });
  }

  SchoolInfosCompanion copyWith({
    Value<int>? id,
    Value<String>? teamName,
    Value<String>? developer,
    Value<String>? planner,
    Value<String>? homepageUrl,
  }) {
    return SchoolInfosCompanion(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      developer: developer ?? this.developer,
      planner: planner ?? this.planner,
      homepageUrl: homepageUrl ?? this.homepageUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (teamName.present) {
      map['team_name'] = Variable<String>(teamName.value);
    }
    if (developer.present) {
      map['developer'] = Variable<String>(developer.value);
    }
    if (planner.present) {
      map['planner'] = Variable<String>(planner.value);
    }
    if (homepageUrl.present) {
      map['homepage_url'] = Variable<String>(homepageUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolInfosCompanion(')
          ..write('id: $id, ')
          ..write('teamName: $teamName, ')
          ..write('developer: $developer, ')
          ..write('planner: $planner, ')
          ..write('homepageUrl: $homepageUrl')
          ..write(')'))
        .toString();
  }
}

class $SpeechSettingsTableTable extends SpeechSettingsTable
    with TableInfo<$SpeechSettingsTableTable, SpeechSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeechSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pitchMeta = const VerificationMeta('pitch');
  @override
  late final GeneratedColumn<int> pitch = GeneratedColumn<int>(
    'pitch',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<int> volume = GeneratedColumn<int>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commandWaitMsMeta = const VerificationMeta(
    'commandWaitMs',
  );
  @override
  late final GeneratedColumn<int> commandWaitMs = GeneratedColumn<int>(
    'command_wait_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultCommandWaitMs),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gender,
    speed,
    pitch,
    volume,
    commandWaitMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speech_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeechSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('pitch')) {
      context.handle(
        _pitchMeta,
        pitch.isAcceptableOrUnknown(data['pitch']!, _pitchMeta),
      );
    } else if (isInserting) {
      context.missing(_pitchMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('command_wait_ms')) {
      context.handle(
        _commandWaitMsMeta,
        commandWaitMs.isAcceptableOrUnknown(
          data['command_wait_ms']!,
          _commandWaitMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeechSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeechSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      )!,
      pitch: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pitch'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume'],
      )!,
      commandWaitMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}command_wait_ms'],
      )!,
    );
  }

  @override
  $SpeechSettingsTableTable createAlias(String alias) {
    return $SpeechSettingsTableTable(attachedDatabase, alias);
  }
}

class SpeechSettingsRow extends DataClass
    implements Insertable<SpeechSettingsRow> {
  final int id;
  final String gender;
  final double speed;
  final int pitch;
  final int volume;

  /// 음성 명령을 안내하기 전에 기다리는 시간 (밀리초). 스키마 2에서 추가.
  final int commandWaitMs;
  const SpeechSettingsRow({
    required this.id,
    required this.gender,
    required this.speed,
    required this.pitch,
    required this.volume,
    required this.commandWaitMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['gender'] = Variable<String>(gender);
    map['speed'] = Variable<double>(speed);
    map['pitch'] = Variable<int>(pitch);
    map['volume'] = Variable<int>(volume);
    map['command_wait_ms'] = Variable<int>(commandWaitMs);
    return map;
  }

  SpeechSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SpeechSettingsTableCompanion(
      id: Value(id),
      gender: Value(gender),
      speed: Value(speed),
      pitch: Value(pitch),
      volume: Value(volume),
      commandWaitMs: Value(commandWaitMs),
    );
  }

  factory SpeechSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeechSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      gender: serializer.fromJson<String>(json['gender']),
      speed: serializer.fromJson<double>(json['speed']),
      pitch: serializer.fromJson<int>(json['pitch']),
      volume: serializer.fromJson<int>(json['volume']),
      commandWaitMs: serializer.fromJson<int>(json['commandWaitMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gender': serializer.toJson<String>(gender),
      'speed': serializer.toJson<double>(speed),
      'pitch': serializer.toJson<int>(pitch),
      'volume': serializer.toJson<int>(volume),
      'commandWaitMs': serializer.toJson<int>(commandWaitMs),
    };
  }

  SpeechSettingsRow copyWith({
    int? id,
    String? gender,
    double? speed,
    int? pitch,
    int? volume,
    int? commandWaitMs,
  }) => SpeechSettingsRow(
    id: id ?? this.id,
    gender: gender ?? this.gender,
    speed: speed ?? this.speed,
    pitch: pitch ?? this.pitch,
    volume: volume ?? this.volume,
    commandWaitMs: commandWaitMs ?? this.commandWaitMs,
  );
  SpeechSettingsRow copyWithCompanion(SpeechSettingsTableCompanion data) {
    return SpeechSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      gender: data.gender.present ? data.gender.value : this.gender,
      speed: data.speed.present ? data.speed.value : this.speed,
      pitch: data.pitch.present ? data.pitch.value : this.pitch,
      volume: data.volume.present ? data.volume.value : this.volume,
      commandWaitMs: data.commandWaitMs.present
          ? data.commandWaitMs.value
          : this.commandWaitMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeechSettingsRow(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('speed: $speed, ')
          ..write('pitch: $pitch, ')
          ..write('volume: $volume, ')
          ..write('commandWaitMs: $commandWaitMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gender, speed, pitch, volume, commandWaitMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeechSettingsRow &&
          other.id == this.id &&
          other.gender == this.gender &&
          other.speed == this.speed &&
          other.pitch == this.pitch &&
          other.volume == this.volume &&
          other.commandWaitMs == this.commandWaitMs);
}

class SpeechSettingsTableCompanion extends UpdateCompanion<SpeechSettingsRow> {
  final Value<int> id;
  final Value<String> gender;
  final Value<double> speed;
  final Value<int> pitch;
  final Value<int> volume;
  final Value<int> commandWaitMs;
  const SpeechSettingsTableCompanion({
    this.id = const Value.absent(),
    this.gender = const Value.absent(),
    this.speed = const Value.absent(),
    this.pitch = const Value.absent(),
    this.volume = const Value.absent(),
    this.commandWaitMs = const Value.absent(),
  });
  SpeechSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String gender,
    required double speed,
    required int pitch,
    required int volume,
    this.commandWaitMs = const Value.absent(),
  }) : gender = Value(gender),
       speed = Value(speed),
       pitch = Value(pitch),
       volume = Value(volume);
  static Insertable<SpeechSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? gender,
    Expression<double>? speed,
    Expression<int>? pitch,
    Expression<int>? volume,
    Expression<int>? commandWaitMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gender != null) 'gender': gender,
      if (speed != null) 'speed': speed,
      if (pitch != null) 'pitch': pitch,
      if (volume != null) 'volume': volume,
      if (commandWaitMs != null) 'command_wait_ms': commandWaitMs,
    });
  }

  SpeechSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? gender,
    Value<double>? speed,
    Value<int>? pitch,
    Value<int>? volume,
    Value<int>? commandWaitMs,
  }) {
    return SpeechSettingsTableCompanion(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      commandWaitMs: commandWaitMs ?? this.commandWaitMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (pitch.present) {
      map['pitch'] = Variable<int>(pitch.value);
    }
    if (volume.present) {
      map['volume'] = Variable<int>(volume.value);
    }
    if (commandWaitMs.present) {
      map['command_wait_ms'] = Variable<int>(commandWaitMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeechSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('speed: $speed, ')
          ..write('pitch: $pitch, ')
          ..write('volume: $volume, ')
          ..write('commandWaitMs: $commandWaitMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $ToursTable tours = $ToursTable(this);
  late final $SchoolInfosTable schoolInfos = $SchoolInfosTable(this);
  late final $SpeechSettingsTableTable speechSettingsTable =
      $SpeechSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    places,
    tours,
    schoolInfos,
    speechSettingsTable,
  ];
}

typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  required String key,
  required String name,
  required int floor,
  required String category,
  required String keywords,
  required String speech,
  required String originalSpeech,
  required int lineIntervalMs,
  Value<String?> imagePath,
  Value<int> rowid,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String> key,
  Value<String> name,
  Value<int> floor,
  Value<String> category,
  Value<String> keywords,
  Value<String> speech,
  Value<String> originalSpeech,
  Value<int> lineIntervalMs,
  Value<String?> imagePath,
  Value<int> rowid,
});

class $$PlacesTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speech => $composableBuilder(
    column: $table.speech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalSpeech => $composableBuilder(
    column: $table.originalSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineIntervalMs => $composableBuilder(
    column: $table.lineIntervalMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speech => $composableBuilder(
    column: $table.speech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalSpeech => $composableBuilder(
    column: $table.originalSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineIntervalMs => $composableBuilder(
    column: $table.lineIntervalMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get floor =>
      $composableBuilder(column: $table.floor, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<String> get speech =>
      $composableBuilder(column: $table.speech, builder: (column) => column);

  GeneratedColumn<String> get originalSpeech => $composableBuilder(
    column: $table.originalSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineIntervalMs => $composableBuilder(
    column: $table.lineIntervalMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
}

class $$PlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTable,
          PlaceRow,
          $$PlacesTableFilterComposer,
          $$PlacesTableOrderingComposer,
          $$PlacesTableAnnotationComposer,
          $$PlacesTableCreateCompanionBuilder,
          $$PlacesTableUpdateCompanionBuilder,
          (PlaceRow, BaseReferences<_$AppDatabase, $PlacesTable, PlaceRow>),
          PlaceRow,
          PrefetchHooks Function()
        > {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> floor = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> keywords = const Value.absent(),
                Value<String> speech = const Value.absent(),
                Value<String> originalSpeech = const Value.absent(),
                Value<int> lineIntervalMs = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesCompanion(
                key: key,
                name: name,
                floor: floor,
                category: category,
                keywords: keywords,
                speech: speech,
                originalSpeech: originalSpeech,
                lineIntervalMs: lineIntervalMs,
                imagePath: imagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String name,
                required int floor,
                required String category,
                required String keywords,
                required String speech,
                required String originalSpeech,
                required int lineIntervalMs,
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesCompanion.insert(
                key: key,
                name: name,
                floor: floor,
                category: category,
                keywords: keywords,
                speech: speech,
                originalSpeech: originalSpeech,
                lineIntervalMs: lineIntervalMs,
                imagePath: imagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacesTable, PlaceRow>(table),
                  BaseReferences<_$AppDatabase, $PlacesTable, PlaceRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTable,
      PlaceRow,
      $$PlacesTableFilterComposer,
      $$PlacesTableOrderingComposer,
      $$PlacesTableAnnotationComposer,
      $$PlacesTableCreateCompanionBuilder,
      $$PlacesTableUpdateCompanionBuilder,
      (PlaceRow, BaseReferences<_$AppDatabase, $PlacesTable, PlaceRow>),
      PlaceRow,
      PrefetchHooks Function()
    >;
typedef $$ToursTableCreateCompanionBuilder = ToursCompanion Function({
  required String key,
  required String name,
  required String description,
  required int durationMinutes,
  required String stops,
  Value<String?> imagePath,
  Value<int> rowid,
});
typedef $$ToursTableUpdateCompanionBuilder = ToursCompanion Function({
  Value<String> key,
  Value<String> name,
  Value<String> description,
  Value<int> durationMinutes,
  Value<String> stops,
  Value<String?> imagePath,
  Value<int> rowid,
});

class $$ToursTableFilterComposer extends Composer<_$AppDatabase, $ToursTable> {
  $$ToursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stops => $composableBuilder(
    column: $table.stops,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ToursTableOrderingComposer
    extends Composer<_$AppDatabase, $ToursTable> {
  $$ToursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stops => $composableBuilder(
    column: $table.stops,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ToursTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToursTable> {
  $$ToursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stops =>
      $composableBuilder(column: $table.stops, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
}

class $$ToursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToursTable,
          TourRow,
          $$ToursTableFilterComposer,
          $$ToursTableOrderingComposer,
          $$ToursTableAnnotationComposer,
          $$ToursTableCreateCompanionBuilder,
          $$ToursTableUpdateCompanionBuilder,
          (TourRow, BaseReferences<_$AppDatabase, $ToursTable, TourRow>),
          TourRow,
          PrefetchHooks Function()
        > {
  $$ToursTableTableManager(_$AppDatabase db, $ToursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ToursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> stops = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToursCompanion(
                key: key,
                name: name,
                description: description,
                durationMinutes: durationMinutes,
                stops: stops,
                imagePath: imagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String name,
                required String description,
                required int durationMinutes,
                required String stops,
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToursCompanion.insert(
                key: key,
                name: name,
                description: description,
                durationMinutes: durationMinutes,
                stops: stops,
                imagePath: imagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToursTable, TourRow>(table),
                  BaseReferences<_$AppDatabase, $ToursTable, TourRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ToursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToursTable,
      TourRow,
      $$ToursTableFilterComposer,
      $$ToursTableOrderingComposer,
      $$ToursTableAnnotationComposer,
      $$ToursTableCreateCompanionBuilder,
      $$ToursTableUpdateCompanionBuilder,
      (TourRow, BaseReferences<_$AppDatabase, $ToursTable, TourRow>),
      TourRow,
      PrefetchHooks Function()
    >;
typedef $$SchoolInfosTableCreateCompanionBuilder =
    SchoolInfosCompanion Function({
      Value<int> id,
      Value<String> teamName,
      Value<String> developer,
      Value<String> planner,
      Value<String> homepageUrl,
    });
typedef $$SchoolInfosTableUpdateCompanionBuilder =
    SchoolInfosCompanion Function({
      Value<int> id,
      Value<String> teamName,
      Value<String> developer,
      Value<String> planner,
      Value<String> homepageUrl,
    });

class $$SchoolInfosTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolInfosTable> {
  $$SchoolInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get developer => $composableBuilder(
    column: $table.developer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planner => $composableBuilder(
    column: $table.planner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homepageUrl => $composableBuilder(
    column: $table.homepageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolInfosTable> {
  $$SchoolInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get developer => $composableBuilder(
    column: $table.developer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planner => $composableBuilder(
    column: $table.planner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homepageUrl => $composableBuilder(
    column: $table.homepageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolInfosTable> {
  $$SchoolInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get teamName =>
      $composableBuilder(column: $table.teamName, builder: (column) => column);

  GeneratedColumn<String> get developer =>
      $composableBuilder(column: $table.developer, builder: (column) => column);

  GeneratedColumn<String> get planner =>
      $composableBuilder(column: $table.planner, builder: (column) => column);

  GeneratedColumn<String> get homepageUrl => $composableBuilder(
    column: $table.homepageUrl,
    builder: (column) => column,
  );
}

class $$SchoolInfosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolInfosTable,
          SchoolInfoRow,
          $$SchoolInfosTableFilterComposer,
          $$SchoolInfosTableOrderingComposer,
          $$SchoolInfosTableAnnotationComposer,
          $$SchoolInfosTableCreateCompanionBuilder,
          $$SchoolInfosTableUpdateCompanionBuilder,
          (
            SchoolInfoRow,
            BaseReferences<_$AppDatabase, $SchoolInfosTable, SchoolInfoRow>,
          ),
          SchoolInfoRow,
          PrefetchHooks Function()
        > {
  $$SchoolInfosTableTableManager(_$AppDatabase db, $SchoolInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> teamName = const Value.absent(),
                Value<String> developer = const Value.absent(),
                Value<String> planner = const Value.absent(),
                Value<String> homepageUrl = const Value.absent(),
              }) => SchoolInfosCompanion(
                id: id,
                teamName: teamName,
                developer: developer,
                planner: planner,
                homepageUrl: homepageUrl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> teamName = const Value.absent(),
                Value<String> developer = const Value.absent(),
                Value<String> planner = const Value.absent(),
                Value<String> homepageUrl = const Value.absent(),
              }) => SchoolInfosCompanion.insert(
                id: id,
                teamName: teamName,
                developer: developer,
                planner: planner,
                homepageUrl: homepageUrl,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SchoolInfosTable, SchoolInfoRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SchoolInfosTable,
                    SchoolInfoRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolInfosTable,
      SchoolInfoRow,
      $$SchoolInfosTableFilterComposer,
      $$SchoolInfosTableOrderingComposer,
      $$SchoolInfosTableAnnotationComposer,
      $$SchoolInfosTableCreateCompanionBuilder,
      $$SchoolInfosTableUpdateCompanionBuilder,
      (
        SchoolInfoRow,
        BaseReferences<_$AppDatabase, $SchoolInfosTable, SchoolInfoRow>,
      ),
      SchoolInfoRow,
      PrefetchHooks Function()
    >;
typedef $$SpeechSettingsTableTableCreateCompanionBuilder =
    SpeechSettingsTableCompanion Function({
      Value<int> id,
      required String gender,
      required double speed,
      required int pitch,
      required int volume,
      Value<int> commandWaitMs,
    });
typedef $$SpeechSettingsTableTableUpdateCompanionBuilder =
    SpeechSettingsTableCompanion Function({
      Value<int> id,
      Value<String> gender,
      Value<double> speed,
      Value<int> pitch,
      Value<int> volume,
      Value<int> commandWaitMs,
    });

class $$SpeechSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SpeechSettingsTableTable> {
  $$SpeechSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pitch => $composableBuilder(
    column: $table.pitch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get commandWaitMs => $composableBuilder(
    column: $table.commandWaitMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpeechSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeechSettingsTableTable> {
  $$SpeechSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pitch => $composableBuilder(
    column: $table.pitch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get commandWaitMs => $composableBuilder(
    column: $table.commandWaitMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeechSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeechSettingsTableTable> {
  $$SpeechSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<int> get pitch =>
      $composableBuilder(column: $table.pitch, builder: (column) => column);

  GeneratedColumn<int> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<int> get commandWaitMs => $composableBuilder(
    column: $table.commandWaitMs,
    builder: (column) => column,
  );
}

class $$SpeechSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeechSettingsTableTable,
          SpeechSettingsRow,
          $$SpeechSettingsTableTableFilterComposer,
          $$SpeechSettingsTableTableOrderingComposer,
          $$SpeechSettingsTableTableAnnotationComposer,
          $$SpeechSettingsTableTableCreateCompanionBuilder,
          $$SpeechSettingsTableTableUpdateCompanionBuilder,
          (
            SpeechSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $SpeechSettingsTableTable,
              SpeechSettingsRow
            >,
          ),
          SpeechSettingsRow,
          PrefetchHooks Function()
        > {
  $$SpeechSettingsTableTableTableManager(
    _$AppDatabase db,
    $SpeechSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeechSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeechSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SpeechSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<double> speed = const Value.absent(),
                Value<int> pitch = const Value.absent(),
                Value<int> volume = const Value.absent(),
                Value<int> commandWaitMs = const Value.absent(),
              }) => SpeechSettingsTableCompanion(
                id: id,
                gender: gender,
                speed: speed,
                pitch: pitch,
                volume: volume,
                commandWaitMs: commandWaitMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String gender,
                required double speed,
                required int pitch,
                required int volume,
                Value<int> commandWaitMs = const Value.absent(),
              }) => SpeechSettingsTableCompanion.insert(
                id: id,
                gender: gender,
                speed: speed,
                pitch: pitch,
                volume: volume,
                commandWaitMs: commandWaitMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpeechSettingsTableTable, SpeechSettingsRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $SpeechSettingsTableTable,
                    SpeechSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpeechSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeechSettingsTableTable,
      SpeechSettingsRow,
      $$SpeechSettingsTableTableFilterComposer,
      $$SpeechSettingsTableTableOrderingComposer,
      $$SpeechSettingsTableTableAnnotationComposer,
      $$SpeechSettingsTableTableCreateCompanionBuilder,
      $$SpeechSettingsTableTableUpdateCompanionBuilder,
      (
        SpeechSettingsRow,
        BaseReferences<
          _$AppDatabase,
          $SpeechSettingsTableTable,
          SpeechSettingsRow
        >,
      ),
      SpeechSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$ToursTableTableManager get tours =>
      $$ToursTableTableManager(_db, _db.tours);
  $$SchoolInfosTableTableManager get schoolInfos =>
      $$SchoolInfosTableTableManager(_db, _db.schoolInfos);
  $$SpeechSettingsTableTableTableManager get speechSettingsTable =>
      $$SpeechSettingsTableTableTableManager(_db, _db.speechSettingsTable);
}
