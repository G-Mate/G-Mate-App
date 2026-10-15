import '../domain/school_info.dart';

/// 처음 들어 있는 학교 개요. 실제 내용이 정해지면 관리 모드에서 바꾼다.
const seedSchoolInfo = SchoolInfo(
  teamName: 'G-Mate',
  blocks: [
    SchoolBlock(
      type: SchoolBlockType.hero,
      title: '인성과 감성으로 감동을 만드는',
      body: '광주소프트웨어마이스터고등학교',
    ),
    SchoolBlock(
      type: SchoolBlockType.heading,
      title: '이런 학과가 있어요',
      body: '세 학과에서 소프트웨어 전문 인재를 길러요',
    ),
    SchoolBlock(
      type: SchoolBlockType.cards,
      cards: [
        SchoolCard(
          emoji: '💻',
          title: '소프트웨어개발과',
          body: '웹·모바일 서비스를 기획부터 개발, 운영까지 배워요',
        ),
        SchoolCard(
          emoji: '🔌',
          title: '스마트IoT과',
          body: '센서와 하드웨어를 다루는 소프트웨어를 만들어요',
        ),
        SchoolCard(
          emoji: '🤖',
          title: '인공지능과',
          body: '데이터와 머신러닝으로 인공지능 서비스를 만들어요',
        ),
      ],
    ),
    SchoolBlock(type: SchoolBlockType.heading, title: '한눈에 보기'),
    SchoolBlock(
      type: SchoolBlockType.text,
      body: '2015년에 문을 열었어요.\n1학년부터 3학년까지 프로젝트로 배우며 성장해요.',
    ),
    SchoolBlock(
      type: SchoolBlockType.link,
      title: '학교 홈페이지',
      url: 'https://gsm.jge.hs.kr/main/main.php',
    ),
  ],
);
