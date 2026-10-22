# G-Mate

temi 로봇 위에서 동작하는 광주소프트웨어마이스터고 안내 Android 앱입니다. 방문객은 화면이나 말로 원하는 장소를 골라 로봇을 따라가고, 학교 투어 코스를 돌며 장소 설명을 듣습니다. 선생님과 관리자는 관리 모드에서 장소, 설명, 투어 코스, 음성을 관리합니다.

> 앱 기능은 에뮬레이터(가짜 로봇)에서 모두 동작합니다. temi 실기 연결과 학교 지도 등록은 아직입니다. 남은 일은 [temi 실기 연결](docs/temi-setup.md)에 정리했습니다.

## 기능

### 방문객

| 기능 | 내용 |
| --- | --- |
| 홈 | 큰 시계와 인사말, 세로로 넘기는 메뉴 카드(길 찾기, 학교 투어, 학교 개요). 가운데 카드를 읽어 주고 말로도 고를 수 있음 |
| 길 찾기 | 장소 선택(분류 칩, 검색) → 장소 확인(사진, 소개, 평면도 미리보기) → 이동 중(층 지도, 안내 중지) → 도착 멘트 후 [설명 듣기]로 본 설명을 자막처럼 한 줄씩. 안내를 마치고 10초 동안 아무 입력이 없으면 홈으로 |
| 학교 투어 | 코스 선택 → 코스 확인 → 장소마다 이동과 설명을 되풀이 → 투어 끝. 이동 실패 시 다시 시도, 건너뛰기, 중지 |
| 학교 개요 | 학교 소개 웹 페이지(학과, 배우는 것, 학교 홈페이지·입학 안내 링크와 QR 코드). 링크는 앱 안 웹 화면으로 엶 |
| 음성 안내·음성 명령 | 화면마다 읽을 말과 할 수 있는 말을 안내하고 temi 음성 인식으로 명령을 들음. 듣는 중에는 오른쪽 위에 작은 동그라미, 알아들으면 그 말을 말풍선으로 잠깐 보여 준 뒤 수행 |

### 관리 모드

홈의 남색 패널을 3초 길게 누르고 PIN(기본 `0000`)을 넣어 들어갑니다.

| 기능 | 내용 |
| --- | --- |
| 장소 관리 | temi 지도에 저장된 위치를 자동으로 앱 장소로 가져오고, 로봇에 저장됨/없음을 보여 줌. [현재 위치 저장]으로 로봇이 선 자리를 temi에 저장하고 새 장소를 만듦. 미리 듣기, 이동 테스트 |
| 장소 편집 | 이름, 분류, 층, 사진, 출발·도착 멘트, 줄 단위 본 설명, 자동 넘김 시간 |
| 투어 관리 | 코스 추가·삭제, 코스 사진·이름·소개·걸리는 시간, 들를 곳 순서(끌어서 바꾸기) |
| 음성 설정 | 목소리, 속도, 높낮이, 음량, 명령 기다리는 시간 |
| PIN 변경 | 지금 PIN 확인 후 새 PIN 두 번 입력 |

장소, 투어, 음성 설정은 기기 DB(drift)에, PIN은 flutter_secure_storage에 저장해 앱을 다시 켜도 남습니다.

## 구조

```
화면(위젯) → Bloc/Cubit → Repository(drift DB)
                        → RobotController ─┬─ FakeRobotController (기본값, 로봇 없이 개발)
                                           └─ TemiRobotController → MethodChannel/EventChannel
                                                                   → Kotlin TemiBridge → temi SDK
```

- Flutter(Dart) · Clean Architecture · flutter_bloc · get_it · go_router · drift
- temi SDK `com.robotemi:sdk:1.138.0` (Kotlin 브리지: 이동, 정지, 말하기, 음성 인식, 위치 목록·저장·삭제)
- 기능 폴더: `home`, `place`, `guide`, `tour`, `school`, `speech`, `admin`

## 시작하기

```bash
flutter pub get
flutter run                                     # 가짜 로봇으로 실행 (기본값)
flutter run --dart-define=USE_FAKE_ROBOT=false  # temi 실기 브리지 사용 (예시 장소·코스 없이 시작)
```

개발용 빌드에서 가짜 로봇을 쓰면 왼쪽 아래 마이크 버튼으로 말을 글로 넣어 음성 명령을 흉내 낼 수 있습니다.

```bash
dart format lib test
flutter analyze
flutter test
```

DB 표를 바꾼 뒤에는 `dart run build_runner build`로 `app_database.g.dart`를 다시 만듭니다.

## 문서

- [temi 실기 연결](docs/temi-setup.md): 지도 등록부터 장소 설정까지 순서와 남은 일
- [Git 컨벤션](docs/conventions/git.md)
- [프로젝트 규칙](docs/conventions/project-rules.md)
- [디자인 시스템](docs/design-system.md)
- [작업 기록](docs/worklog.md): Notion "G-Mate > v1"로 옮기기 전 임시 기록
- [설계안](https://claude.ai/code/artifact/4587d550-0734-4a9e-b9e7-7872be0943ec)
