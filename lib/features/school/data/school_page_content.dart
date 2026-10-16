import '../domain/school_page.dart';

/// 학교 개요 페이지 내용. 관리 모드에서 고치지 않고 앱에 고정해 둔다.
///
/// 학교 홈페이지(gsm.jge.hs.kr)와 입학지원 서비스(hellogsm.kr)의 소개를
/// 바탕으로 짧게 다시 썼다. 내용이 바뀌면 여기를 고친다. 이어진 링크는
/// 옆으로 넘기는 한 줄로 보인다.
const schoolPageBlocks = [
  SchoolBlock(
    type: SchoolBlockType.hero,
    title: '인성과 감성으로 감동을 만드는',
    body: '광주소프트웨어마이스터고등학교',
  ),

  SchoolBlock(
    type: SchoolBlockType.heading,
    title: '어떤 학교인가요?',
    body: '소프트웨어 분야의 영 마이스터를 기르는 학교예요',
  ),
  SchoolBlock(
    type: SchoolBlockType.text,
    body:
        '광주소프트웨어마이스터고등학교(GSM)는 소프트웨어 산업에서 일할 '
        '전문 인재를 기르는 마이스터고등학교예요.\n'
        '2015년에 문을 열었고, 학생들은 3년 동안 수업과 프로젝트로 실제 '
        '서비스를 만들며 배워요.',
  ),

  SchoolBlock(
    type: SchoolBlockType.heading,
    title: '세 학과',
    body: '관심 분야에 맞춰 깊이 배워요',
  ),
  SchoolBlock(
    type: SchoolBlockType.cards,
    cards: [
      SchoolCard(
        emoji: '💻',
        title: '소프트웨어개발과',
        body: '기획·설계부터 개발·유지보수까지, 웹과 모바일 서비스를 만드는 개발자를 길러요',
      ),
      SchoolCard(
        emoji: '🔌',
        title: '스마트IoT과',
        body: '센서와 하드웨어로 사물을 인터넷에 잇는 IT 융합 소프트웨어를 만들어요',
      ),
      SchoolCard(
        emoji: '🤖',
        title: '인공지능과',
        body: '빅데이터와 머신러닝으로 인공지능 서비스를 기획하고 만들어요',
      ),
    ],
  ),

  SchoolBlock(
    type: SchoolBlockType.heading,
    title: '이렇게 배워요',
    body: '현장에서 바로 일할 수 있는 힘을 길러요',
  ),
  SchoolBlock(
    type: SchoolBlockType.cards,
    cards: [
      SchoolCard(
        emoji: '🎯',
        title: '취업 역량',
        body: '직업군에 맞춘 교육과정으로 취업할 힘을 키워요',
      ),
      SchoolCard(
        emoji: '💪',
        title: '현장 실무',
        body: '산업 현장의 변화에 맞춘 실습으로 실무 능력을 높여요',
      ),
      SchoolCard(
        emoji: '💡',
        title: '자기 주도 학습',
        body: '스스로 정한 프로젝트로 배우는 힘을 길러요',
      ),
      SchoolCard(
        emoji: '🚀',
        title: '창의 융합',
        body: '여러 분야를 엮어 새로운 것을 만드는 글로벌 인재로 자라요',
      ),
      SchoolCard(
        emoji: '🧑‍🤝‍🧑',
        title: '인성과 감성',
        body: '함께 일하는 동료를 존중하는 개발자로 성장해요',
      ),
      SchoolCard(
        emoji: '🏫',
        title: '기숙사 생활',
        body: '학교 안 기숙사에서 친구들과 함께 생활하며 배워요',
      ),
    ],
  ),

  SchoolBlock(
    type: SchoolBlockType.heading,
    title: '더 알아보기',
    body: '눌러서 보거나, 휴대폰 카메라로 QR 코드를 찍어 보세요',
  ),
  SchoolBlock(
    type: SchoolBlockType.link,
    title: '학교 홈페이지',
    body: '학교 소식과 공지사항',
    url: 'https://gsm.jge.hs.kr/main/main.php',
  ),
  SchoolBlock(
    type: SchoolBlockType.link,
    title: '입학 안내 (Hello, GSM)',
    body: '신입생 모집과 원서 접수',
    url: 'https://www.hellogsm.kr/',
  ),
  SchoolBlock(
    type: SchoolBlockType.link,
    title: '학과 체험',
    body: 'Ready, GSM에서 학과 체험 신청',
    url: 'https://www.ready.hellogsm.kr/',
  ),
  SchoolBlock(
    type: SchoolBlockType.link,
    title: '나무위키',
    body: '학교에 대해 더 알아보기',
    url:
        'https://namu.wiki/w/'
        '%EA%B4%91%EC%A3%BC%EC%86%8C%ED%94%84%ED%8A%B8%EC%9B%A8%EC%96%B4'
        '%EB%A7%88%EC%9D%B4%EC%8A%A4%ED%84%B0%EA%B3%A0%EB%93%B1%ED%95%99%EA%B5%90',
  ),
];

/// 페이지 맨 아래에 작게 보이는 만든 팀.
const schoolPageCredit = '이 안내 로봇 앱은 G-Mate 팀이 만들었어요';
