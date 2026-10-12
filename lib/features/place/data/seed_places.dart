import '../domain/place.dart';

/// 처음 들어 있는 장소. 실제 학교 장소와 멘트가 정해지면 바꾼다.
const seedPlaces = [
  Place(
    key: 'science_lab',
    name: '과학실',
    floor: 3,
    category: PlaceCategory.classroom,
    keywords: ['실험실', '과학'],
    speech: _scienceLab,
    originalSpeech: _scienceLab,
  ),
  Place(
    key: 'computer_lab',
    name: '컴퓨터실',
    floor: 3,
    category: PlaceCategory.classroom,
    keywords: ['전산실', '컴퓨터', 'PC'],
    speech: _computerLab,
    originalSpeech: _computerLab,
  ),
  Place(
    key: 'teachers_office',
    name: '교무실',
    floor: 2,
    category: PlaceCategory.office,
    keywords: ['선생님', '교무'],
    speech: _teachersOffice,
    originalSpeech: _teachersOffice,
  ),
  Place(
    key: 'admin_office',
    name: '행정실',
    floor: 1,
    category: PlaceCategory.office,
    keywords: ['서류', '증명서', '행정'],
    speech: _adminOffice,
    originalSpeech: _adminOffice,
  ),
  Place(
    key: 'library',
    name: '도서관',
    floor: 2,
    category: PlaceCategory.facility,
    keywords: ['도서실', '책'],
    speech: _library,
    originalSpeech: _library,
  ),
  Place(
    key: 'auditorium',
    name: '강당',
    floor: 1,
    category: PlaceCategory.facility,
    keywords: ['체육관', '행사'],
    speech: _auditorium,
    originalSpeech: _auditorium,
  ),
];

const _scienceLab = PlaceSpeech(
  start: '과학실로 안내할게요. 저를 따라와 주세요.',
  arrival: '과학실에 도착했어요.',
  descriptionLines: [
    '과학실은 3층 동쪽 끝에 있어요.',
    '실험 도구와 안전 장비가 갖춰진 교실입니다.',
    '물리, 화학, 생명과학 수업이 이곳에서 열려요.',
    '실험할 때는 꼭 보안경을 써 주세요.',
  ],
);

const _computerLab = PlaceSpeech(
  start: '컴퓨터실로 안내할게요. 저를 따라와 주세요.',
  arrival: '컴퓨터실에 도착했어요.',
  descriptionLines: [
    '컴퓨터실은 3층 가운데에 있어요.',
    '학생마다 한 대씩 쓸 수 있는 컴퓨터가 있습니다.',
    '프로그래밍 수업과 프로젝트 실습을 이곳에서 해요.',
  ],
);

const _teachersOffice = PlaceSpeech(
  start: '교무실로 안내할게요. 저를 따라와 주세요.',
  arrival: '교무실에 도착했어요.',
  descriptionLines: ['교무실은 선생님들이 계신 곳이에요.', '선생님을 찾으시면 문 앞에서 노크해 주세요.'],
);

const _adminOffice = PlaceSpeech(
  start: '행정실로 안내할게요. 저를 따라와 주세요.',
  arrival: '행정실에 도착했어요.',
  descriptionLines: [
    '행정실에서는 증명서 발급과 학교 행정 업무를 도와드려요.',
    '평일 오전 9시부터 오후 5시까지 열려 있어요.',
  ],
);

const _library = PlaceSpeech(
  start: '도서관으로 안내할게요. 저를 따라와 주세요.',
  arrival: '도서관에 도착했어요.',
  descriptionLines: [
    '도서관은 2층에 있는 조용한 공간이에요.',
    '책을 빌리거나 자습을 할 수 있어요.',
    '안에서는 조용히 이야기해 주세요.',
  ],
);

const _auditorium = PlaceSpeech(
  start: '강당으로 안내할게요. 저를 따라와 주세요.',
  arrival: '강당에 도착했어요.',
  descriptionLines: ['강당은 입학식과 졸업식 같은 큰 행사가 열리는 곳이에요.', '체육 수업도 이곳에서 해요.'],
);
