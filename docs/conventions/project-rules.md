# 프로젝트 규칙

G-Mate 앱 코드를 작성할 때 지키는 규칙입니다. 설계 배경은 [설계안](https://claude.ai/code/artifact/4587d550-0734-4a9e-b9e7-7872be0943ec)에 있습니다.

## 범위

- v1은 temi 위에서 도는 Android 앱만 만듭니다. 서버·웹 관리 화면은 범위 밖입니다.
- UI와 앱 로직은 Flutter(Dart), temi SDK 연동은 Kotlin 네이티브 브리지가 맡습니다.

## 아키텍처

Clean Architecture + flutter_bloc을 씁니다.

```
presentation (화면, Bloc/Cubit)
      ↓
domain (Entity, Repository 인터페이스, UseCase)
      ↑
data (Repository 구현, DataSource, Model)
```

- 의존성은 항상 바깥에서 안쪽(`presentation → domain ← data`)으로만 향합니다. `domain`은 Flutter, 플랫폼 채널, DB 패키지를 import하지 않습니다.
- 화면(위젯)은 Bloc만 바라봅니다. 위젯에서 Repository, `RobotController`, 플랫폼 채널을 직접 부르지 않습니다.
- temi 호출은 모두 `RobotController`(추상 클래스) 하나를 거칩니다.
  - `TemiRobotController`: MethodChannel/EventChannel로 Kotlin 브리지를 부르는 실제 구현
  - `FakeRobotController`: 로봇 없이 개발·테스트할 때 쓰는 가짜 구현. 로봇 지도가 준비되기 전까지 기본값입니다.
- 의존성 주입은 get_it으로 `lib/app/di.dart` 한 곳에서 등록합니다.
- 라우팅은 go_router로 `lib/app/router.dart` 한 곳에서 정의합니다.

### 결정 상태

| 항목 | 선택 | 상태 |
| --- | --- | --- |
| 상태 관리 | flutter_bloc | 확정 |
| 아키텍처 | Clean Architecture | 확정 |
| 의존성 주입 | get_it | 검토 중 기본값 |
| 라우팅 | go_router | 검토 중 기본값 |
| 로컬 DB | drift | 검토 중 기본값 (적용됨) |
| 비밀값 저장 (관리 모드 PIN) | flutter_secure_storage | 검토 중 기본값 (적용됨) |

검토 중인 항목을 바꾸면 이 표와 관련 코드를 함께 고칩니다.

## 폴더 구조

```
lib/
├── main.dart                 # 진입점: DI 초기화 후 App 실행
├── app/                      # 앱 전역 조립
│   ├── app.dart              # MaterialApp.router, 테마
│   ├── di.dart               # get_it 등록
│   └── router.dart           # go_router 라우트
├── core/                     # 여러 기능이 같이 쓰는 코드
│   ├── design_system.dart    # 디자인 시스템 한 번에 import
│   ├── robot/                # RobotController 추상화와 구현
│   ├── theme/                # 디자인 토큰과 테마
│   └── widgets/              # 공통 위젯 (Gm 접두사)
└── features/                 # 기능별 폴더
    └── <기능>/
        ├── data/
        ├── domain/
        └── presentation/
android/app/src/main/kotlin/  # temi 브리지 (Kotlin)
test/                         # lib/ 구조를 그대로 따라감
docs/                         # 문서
```

기능 폴더 이름은 `place`(공간 지정), `guide`(길 찾기), `tour`(안내 경로), `speech`(설명 음성), `admin`(관리 모드), `school`(학교 개요), `home`을 씁니다. 필요할 때 만들고, 빈 폴더를 미리 만들어 두지 않습니다.

## 코드 스타일

- `flutter analyze`에 경고가 없어야 합니다. 규칙은 [analysis_options.yaml](../../analysis_options.yaml)을 따릅니다.
- `dart format`으로 포맷합니다 (줄 길이 기본값 80).
- 파일 이름은 `snake_case.dart`, 클래스는 `PascalCase`, 변수·함수는 `camelCase`.
- Bloc 파일은 `xxx_bloc.dart`, `xxx_event.dart`, `xxx_state.dart`로 나누고, 상태 비교에는 equatable을 씁니다.
- 코드 안 주석과 사용자에게 보이는 문구는 한국어, 식별자는 영어로 씁니다.
- 매직 넘버(재시도 횟수, 대기 시간 등)는 이름 있는 상수로 둡니다.

## 화면 규칙

- 색, 글자 크기, 간격은 [디자인 시스템](../design-system.md)의 토큰과 테마로만 씁니다. 화면에 `Color(0x...)`, `fontSize` 숫자를 직접 쓰지 않습니다.
- 방문객 화면의 누르는 요소는 최소 64dp입니다.

## 데이터 저장 규칙

- 장소, 투어 코스, 학교 소개, 음성 설정은 로컬 DB(`lib/core/database/app_database.dart`, drift)에 둡니다. 관리 모드 PIN만 flutter_secure_storage에 둡니다.
- 표 정의는 `core/database`에, 표 ↔ 도메인 값 변환은 기능별 `data/`의 `DriftXxxRepository`에 둡니다.
- 처음 DB를 만들 때만 `lib/app/database_seed.dart`가 기본 내용을 넣습니다. 이미 설치된 기기의 내용은 바꾸지 않습니다.
- 표를 바꾸면 `schemaVersion`을 올리고 `migration`에 옮기는 단계를 넣은 뒤, `dart run build_runner build`로 `app_database.g.dart`를 다시 만들어 함께 커밋합니다.
- 장소 사진은 앱 문서 폴더(`place_photos/`)에 복사하고 DB에는 경로만 둡니다.
- 테스트는 `InMemoryXxxRepository`를 쓰고, drift 저장소 자체는 `NativeDatabase.memory()`로 테스트합니다.

## 플랫폼 채널 규칙

| 채널 | 종류 | 용도 |
| --- | --- | --- |
| `gmate/robot` | MethodChannel | Dart → Kotlin 명령 (`goTo`, `speak`, `saveLocation` 등) |
| `gmate/robot/events` | EventChannel | Kotlin → Dart 이벤트 (이동 상태, TTS 상태, 장소 변경 등) |

- 채널 이름은 `lib/core/robot/robot_channels.dart`와 Kotlin `RobotChannels`에 상수로 두고, 두 곳을 항상 함께 고칩니다.
- 메서드 이름은 temi SDK 메서드 이름을 그대로 씁니다 (`goTo`, `stopMovement`).
- 이벤트는 `{"type": "...", ...}` 형태의 Map으로 보내고, Dart 쪽에서 타입 있는 이벤트 클래스로 바꿉니다.
- temi SDK는 `onRobotReady(true)` 이후에만 호출합니다.

## temi 장소 키

- temi에 저장하는 장소 이름은 영문 소문자 키(`science_lab`)를 쓰고, 한국어 표시명은 앱 DB에 따로 둡니다.

## 테스트

- 도메인 로직(Bloc, UseCase, 투어 상태 머신)은 `FakeRobotController`로 단위 테스트를 씁니다.
- 실기에서만 확인할 수 있는 동작(이동, 감지)은 PR 본문에 실기 확인 여부를 적습니다.

## 문서와 기록

- 작업이 끝나면 [작업 기록](../worklog.md)에 **완료한 작업만** 적습니다. 할 일 목록으로 쓰지 않습니다.
- 트러블슈팅은 **실제로 겪은 문제만** 적습니다. 예상 이슈를 미리 적지 않습니다.
- 기록 항목에 ID(번호)를 붙이지 않습니다. GitHub 이슈 번호는 브랜치·PR에서만 씁니다.
- 작업 기록은 나중에 Notion "G-Mate > v1"의 작업 기록·이슈 DB로 옮깁니다. 옮긴 항목은 표시해 둡니다.
- 규칙이 바뀌면 코드보다 이 문서를 먼저 고칩니다.
