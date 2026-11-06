import 'dart:ui';

/// 배치도 위 칸의 종류.
enum FloorRoomKind {
  /// 안내할 수 있는 방 (장소 키가 있다).
  room,

  /// 계단, 창고처럼 그리기만 하는 칸.
  service,

  /// 건물 출입문.
  door,
}

/// 복도 이름. 방 문이 어느 복도에 붙어 있는지 나타낸다.
enum FloorCorridor { west, east }

/// 배치도 한 칸.
class FloorRoom {
  const FloorRoom(
    this.label,
    this.rect, {
    this.key,
    this.door,
    this.corridor = FloorCorridor.east,
    this.kind = FloorRoomKind.service,
  });

  /// 칸 안에 쓰는 이름. 줄바꿈(`\n`)으로 여러 줄을 쓴다.
  final String label;

  /// 배치도 좌표의 칸.
  final Rect rect;

  /// 앱 장소 키 (temi 위치 이름). 안내할 수 있는 방만 있다.
  final String? key;

  /// 복도에서 들어가는 문 자리.
  final Offset? door;
  final FloorCorridor corridor;
  final FloorRoomKind kind;
}

/// 학교 1층 배치도 (본관 1F + 실습동 1F).
///
/// temi는 층을 오가지 못해서 1층 하나만 지도로 쓴다. 좌표는 학교 배치도
/// PDF(본관 배치도 쪽)의 1층 그림을 그대로 옮긴 단위이고, 화면에서는
/// [bounds]를 칸에 맞춰 줄인다. 방 키는 예시 장소(`seed_places.dart`)와 같다.
abstract final class FirstFloorLayout {
  /// 로봇 충전 위치(home base). 본관 가운데 출입문 앞 복도로 둔다.
  static const homeBase = Offset(506, 402);

  /// 서쪽(본관 왼쪽) 복도 가운데 선의 y.
  static const westCorridorY = 346.0;

  /// 동쪽(본관 오른쪽 ~ 실습동) 복도 가운데 선의 y.
  static const eastCorridorY = 402.0;

  /// 두 복도를 잇는 가운데 복도의 x.
  static const centralCorridorX = 506.0;

  /// 복도 바닥.
  static const corridors = [
    Rect.fromLTRB(125, 318, 482, 375),
    Rect.fromLTRB(482, 205, 530, 432),
    Rect.fromLTRB(530, 375, 1258, 430),
    Rect.fromLTRB(833, 345, 935, 375),
  ];

  static const rooms = [
    // 본관 서쪽.
    FloorRoom(
      '여자\n화장실',
      Rect.fromLTRB(70, 263, 123, 373),
      key: 'restroom_women',
      door: Offset(123, 346),
      corridor: FloorCorridor.west,
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      '보건실\n상담실',
      Rect.fromLTRB(125, 207, 202, 318),
      key: 'health_room',
      door: Offset(163, 318),
      corridor: FloorCorridor.west,
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      '교장실',
      Rect.fromLTRB(205, 207, 328, 318),
      key: 'principal_office',
      door: Offset(266, 318),
      corridor: FloorCorridor.west,
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      '행정실',
      Rect.fromLTRB(331, 207, 479, 318),
      key: 'admin_office',
      door: Offset(400, 318),
      corridor: FloorCorridor.west,
      kind: FloorRoomKind.room,
    ),
    FloorRoom('계단', Rect.fromLTRB(70, 375, 123, 430)),
    FloorRoom(
      '출입문',
      Rect.fromLTRB(125, 375, 180, 430),
      kind: FloorRoomKind.door,
    ),
    FloorRoom(
      '엘리\n베이터',
      Rect.fromLTRB(270, 375, 325, 430),
      key: 'elevator',
      door: Offset(297, 375),
      corridor: FloorCorridor.west,
      kind: FloorRoomKind.room,
    ),
    FloorRoom('계단', Rect.fromLTRB(403, 375, 479, 430)),
    // 가운데 출입문 (위아래).
    FloorRoom(
      '출입문',
      Rect.fromLTRB(482, 150, 530, 205),
      kind: FloorRoomKind.door,
    ),
    FloorRoom(
      '출입문',
      Rect.fromLTRB(482, 432, 530, 465),
      kind: FloorRoomKind.door,
    ),
    // 본관 동쪽.
    FloorRoom(
      '방송실',
      Rect.fromLTRB(533, 263, 604, 375),
      key: 'broadcast_room',
      door: Offset(568, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      'Community\nZone',
      Rect.fromLTRB(607, 263, 679, 375),
      key: 'community_zone',
      door: Offset(643, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      '교무실',
      Rect.fromLTRB(682, 263, 780, 375),
      key: 'teachers_office',
      door: Offset(731, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      '교감실',
      Rect.fromLTRB(783, 263, 830, 375),
      key: 'vice_principal_office',
      door: Offset(806, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom('창고', Rect.fromLTRB(833, 263, 880, 345)),
    FloorRoom('계단', Rect.fromLTRB(883, 263, 935, 345)),
    FloorRoom(
      '남자\n화장실',
      Rect.fromLTRB(938, 235, 992, 375),
      key: 'restroom_men',
      door: Offset(965, 375),
      kind: FloorRoomKind.room,
    ),
    // 실습동.
    FloorRoom('창고', Rect.fromLTRB(995, 235, 1047, 318)),
    FloorRoom('세면대', Rect.fromLTRB(995, 318, 1047, 375)),
    FloorRoom(
      'AI서비스\n구현\n실습실',
      Rect.fromLTRB(1050, 235, 1125, 375),
      key: 'ai_service_lab',
      door: Offset(1087, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom(
      '체력\n단련실',
      Rect.fromLTRB(1128, 235, 1203, 375),
      key: 'fitness_room',
      door: Offset(1165, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom('준비실', Rect.fromLTRB(1206, 235, 1258, 290)),
    FloorRoom(
      '인쇄실',
      Rect.fromLTRB(1206, 292, 1258, 375),
      key: 'print_room',
      door: Offset(1232, 375),
      kind: FloorRoomKind.room,
    ),
    FloorRoom('서버실', Rect.fromLTRB(1261, 348, 1315, 430)),
    FloorRoom(
      '출입문',
      Rect.fromLTRB(1150, 432, 1205, 465),
      kind: FloorRoomKind.door,
    ),
    FloorRoom('계단', Rect.fromLTRB(1208, 432, 1310, 465)),
  ];

  /// 배치도 전체를 감싸는 칸.
  static final Rect bounds = [
    for (final r in rooms) r.rect,
    ...corridors,
  ].reduce((a, b) => a.expandToInclude(b));

  /// 장소 키가 [key]인 방. 배치도에 없으면 null.
  static FloorRoom? room(String? key) {
    if (key == null) return null;
    for (final r in rooms) {
      if (r.key == key) return r;
    }
    return null;
  }

  /// [from] 방(없으면 충전 위치)에서 [to] 방까지 복도를 따라가는 꺾인 선.
  /// [to]가 배치도에 없으면 null.
  static List<Offset>? route({String? from, required String to}) {
    final target = room(to);
    if (target?.door == null) return null;
    final start = room(from);
    final (startPoint, startCorridor) = start?.door == null
        ? (homeBase, FloorCorridor.east)
        : (start!.door!, start.corridor);
    final endPoint = target!.door!;

    double y(FloorCorridor c) =>
        c == FloorCorridor.west ? westCorridorY : eastCorridorY;

    final points = [
      startPoint,
      Offset(startPoint.dx, y(startCorridor)),
      if (startCorridor != target.corridor) ...[
        Offset(centralCorridorX, y(startCorridor)),
        Offset(centralCorridorX, y(target.corridor)),
      ],
      Offset(endPoint.dx, y(target.corridor)),
      endPoint,
    ];
    // 같은 점이 이어지면 하나만 남긴다.
    return [
      for (var i = 0; i < points.length; i++)
        if (i == 0 || points[i] != points[i - 1]) points[i],
    ];
  }
}
