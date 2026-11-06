import '../domain/place.dart';

/// 처음 들어 있는 장소: 학교 배치도의 1층(본관·실습동) 장소.
///
/// temi는 층을 오가지 못해서 1층만 지도로 쓴다. 키는 temi에 저장할 위치 이름이고
/// 1층 평면도(`FirstFloorLayout`)의 방 키와 같다. temi 지도에서 이 이름으로 위치를
/// 저장하면 장소 관리에서 가져올 때 아래 이름·분류·멘트가 그대로 채워진다.
/// 멘트와 본 설명은 초안이라 관리 모드에서 고친다.
const seedPlaces = [
  Place(
    key: 'admin_office',
    name: '행정실',
    category: PlaceCategory.office,
    keywords: ['서류', '증명서', '행정'],
    speech: _adminOffice,
    originalSpeech: _adminOffice,
  ),
  Place(
    key: 'teachers_office',
    name: '교무실',
    category: PlaceCategory.office,
    keywords: ['선생님', '교무'],
    speech: _teachersOffice,
    originalSpeech: _teachersOffice,
  ),
  Place(
    key: 'principal_office',
    name: '교장실',
    category: PlaceCategory.office,
    keywords: ['교장', '교장 선생님'],
    speech: _principalOffice,
    originalSpeech: _principalOffice,
  ),
  Place(
    key: 'vice_principal_office',
    name: '교감실',
    category: PlaceCategory.office,
    keywords: ['교감', '교감 선생님'],
    speech: _vicePrincipalOffice,
    originalSpeech: _vicePrincipalOffice,
  ),
  Place(
    key: 'health_room',
    name: '보건실',
    category: PlaceCategory.facility,
    keywords: ['상담실', '성고충상담실', '아플 때', '보건'],
    speech: _healthRoom,
    originalSpeech: _healthRoom,
  ),
  Place(
    key: 'broadcast_room',
    name: '방송실',
    category: PlaceCategory.office,
    keywords: ['방송'],
    speech: _broadcastRoom,
    originalSpeech: _broadcastRoom,
  ),
  Place(
    key: 'community_zone',
    name: '커뮤니티존',
    category: PlaceCategory.facility,
    keywords: ['Community Zone', '커뮤니티', '쉼터', '휴게'],
    speech: _communityZone,
    originalSpeech: _communityZone,
  ),
  Place(
    key: 'ai_service_lab',
    name: 'AI서비스구현실습실',
    building: PlaceBuilding.practice,
    category: PlaceCategory.classroom,
    keywords: ['AI', '인공지능', '실습실', '에이아이'],
    speech: _aiServiceLab,
    originalSpeech: _aiServiceLab,
  ),
  Place(
    key: 'fitness_room',
    name: '체력단련실',
    building: PlaceBuilding.practice,
    category: PlaceCategory.facility,
    keywords: ['헬스장', '운동', '헬스'],
    speech: _fitnessRoom,
    originalSpeech: _fitnessRoom,
  ),
  Place(
    key: 'restroom_women',
    name: '여자 화장실',
    category: PlaceCategory.facility,
    keywords: ['화장실', '여자화장실'],
    speech: _restroomWomen,
    originalSpeech: _restroomWomen,
  ),
  Place(
    key: 'restroom_men',
    name: '남자 화장실',
    category: PlaceCategory.facility,
    keywords: ['화장실', '남자화장실'],
    speech: _restroomMen,
    originalSpeech: _restroomMen,
  ),
  Place(
    key: 'elevator',
    name: '엘리베이터',
    category: PlaceCategory.facility,
    keywords: ['승강기', '엘베', '위층'],
    speech: _elevator,
    originalSpeech: _elevator,
  ),
  Place(
    key: 'print_room',
    name: '인쇄실',
    building: PlaceBuilding.practice,
    category: PlaceCategory.office,
    keywords: ['인쇄', '복사'],
    speech: _printRoom,
    originalSpeech: _printRoom,
  ),
];

const _adminOffice = PlaceSpeech(
  start: '행정실로 안내할게요. 저를 따라와 주세요.',
  arrival: '행정실에 도착했어요.',
  descriptionLines: ['행정실은 본관 1층 가운데 출입문 왼쪽에 있어요.', '증명서 발급과 학교 행정 업무를 도와드려요.'],
);

const _teachersOffice = PlaceSpeech(
  start: '교무실로 안내할게요. 저를 따라와 주세요.',
  arrival: '교무실에 도착했어요.',
  descriptionLines: ['교무실은 선생님들이 계신 곳이에요.', '선생님을 찾으시면 문 앞에서 노크해 주세요.'],
);

const _principalOffice = PlaceSpeech(
  start: '교장실로 안내할게요. 저를 따라와 주세요.',
  arrival: '교장실에 도착했어요.',
  descriptionLines: ['교장실은 행정실 옆에 있어요.', '방문하실 때는 행정실에 먼저 말씀해 주세요.'],
);

const _vicePrincipalOffice = PlaceSpeech(
  start: '교감실로 안내할게요. 저를 따라와 주세요.',
  arrival: '교감실에 도착했어요.',
  descriptionLines: ['교감실은 교무실 바로 옆에 있어요.'],
);

const _healthRoom = PlaceSpeech(
  start: '보건실로 안내할게요. 저를 따라와 주세요.',
  arrival: '보건실에 도착했어요.',
  descriptionLines: [
    '보건실은 본관 1층 서쪽 끝에 있어요.',
    '몸이 아프거나 다쳤을 때 찾아오세요.',
    '성고충 상담실도 같은 곳에 있어요.',
  ],
);

const _broadcastRoom = PlaceSpeech(
  start: '방송실로 안내할게요. 저를 따라와 주세요.',
  arrival: '방송실에 도착했어요.',
  descriptionLines: ['방송실은 학교 방송을 하는 곳이에요.'],
);

const _communityZone = PlaceSpeech(
  start: '커뮤니티존으로 안내할게요. 저를 따라와 주세요.',
  arrival: '커뮤니티존에 도착했어요.',
  descriptionLines: ['커뮤니티존은 학생들이 모여 이야기하고 쉬는 공간이에요.'],
);

const _aiServiceLab = PlaceSpeech(
  start: 'AI서비스구현실습실로 안내할게요. 저를 따라와 주세요.',
  arrival: 'AI서비스구현실습실에 도착했어요.',
  descriptionLines: ['AI서비스구현실습실은 실습동 1층에 있어요.', '인공지능 서비스를 직접 만들어 보는 실습실이에요.'],
);

const _fitnessRoom = PlaceSpeech(
  start: '체력단련실로 안내할게요. 저를 따라와 주세요.',
  arrival: '체력단련실에 도착했어요.',
  descriptionLines: ['체력단련실은 실습동 1층에 있어요.', '운동 기구로 체력을 기르는 곳이에요.'],
);

const _restroomWomen = PlaceSpeech(
  start: '여자 화장실로 안내할게요. 저를 따라와 주세요.',
  arrival: '여자 화장실에 도착했어요.',
  descriptionLines: ['여자 화장실은 본관 1층 서쪽 끝에 있어요.'],
);

const _restroomMen = PlaceSpeech(
  start: '남자 화장실로 안내할게요. 저를 따라와 주세요.',
  arrival: '남자 화장실에 도착했어요.',
  descriptionLines: ['남자 화장실은 본관과 실습동 사이에 있어요.'],
);

const _elevator = PlaceSpeech(
  start: '엘리베이터로 안내할게요. 저를 따라와 주세요.',
  arrival: '엘리베이터에 도착했어요.',
  descriptionLines: ['다른 층으로 가시려면 이 엘리베이터를 타 주세요.', '저는 1층만 안내할 수 있어요.'],
);

const _printRoom = PlaceSpeech(
  start: '인쇄실로 안내할게요. 저를 따라와 주세요.',
  arrival: '인쇄실에 도착했어요.',
  descriptionLines: ['인쇄실은 실습동 1층 끝에 있어요.'],
);
