# 작업 기록

Notion "G-Mate > v1"의 작업 기록·이슈 DB로 옮기기 전에 임시로 적어 두는 곳입니다.

- **작업 기록**에는 완료한 작업만 적습니다. 할 일은 적지 않습니다.
- **트러블슈팅**에는 실제로 겪은 문제만 적습니다.
- 항목에 ID를 붙이지 않습니다. 분야는 화면(UI) · 로봇 연동 · 데이터 · 공통 중 하나입니다.
- Notion으로 옮긴 항목은 `Notion` 칸에 ✓를 표시합니다.

## 작업 기록

| 작업 | 분야 | 완료일 | 내용 | Notion |
| --- | --- | --- | --- | --- |
| 저장소 연결 | 공통 | 2026-10-11 | GitHub G-Mate/G-Mate-App 저장소를 프로젝트에 연결 (빈 저장소에서 시작) | |
| Git 컨벤션 문서 작성 | 공통 | 2026-10-11 | GitHub Flow, 이슈 번호를 붙인 브랜치 이름(`feat/12-place-list-screen`), Conventional Commits(한국어 제목), PR·Squash merge 규칙을 [git.md](conventions/git.md)에 정리. 커밋 템플릿 `.gitmessage`, PR 템플릿 추가 | |
| 프로젝트 규칙 문서 작성 | 공통 | 2026-10-11 | 아키텍처, 폴더 구조, 코드 스타일, 플랫폼 채널, 테스트, 기록 규칙을 [project-rules.md](conventions/project-rules.md)에 정리 | |
| Flutter 프로젝트 생성 | 공통 | 2026-10-11 | Flutter 3.47.7로 Android 전용 프로젝트 생성 (패키지 `com.gmate.g_mate`). flutter_bloc, equatable, get_it, go_router 추가 | |
| 앱 기본 구조 세팅 | 화면(UI) | 2026-10-11 | `app/`(DI·라우터·테마) + `core/` + `features/` 구조, 홈(대기) 화면과 로봇 준비 상태 표시 | |
| RobotController 추상화 | 로봇 연동 | 2026-10-11 | `RobotController` 인터페이스, 로봇 이벤트 타입, `FakeRobotController`(이동·TTS 시뮬레이션), 채널 기반 `TemiRobotController`. 단위 테스트 6개 통과 | |
| Kotlin temi 브리지 뼈대 | 로봇 연동 | 2026-10-11 | `gmate/robot` MethodChannel, `gmate/robot/events` EventChannel을 여는 `TemiBridge`. temi SDK 의존성은 아직 없음 | |
| 디자인 시스템 적용 | 화면(UI) | 2026-10-11 | 색·글자·간격 토큰과 `AppTheme`, 공통 위젯 7종(`GmScaffold`, `GmButton`, `GmMenuTile`, `GmCard`, `GmChoiceChip`, `GmStatusBanner`, `GmEmptyState`), 미리보기 화면(`/design-gallery`) 추가. 홈 화면에 적용. 색은 파랑 계열, 테두리 대신 그림자·면 색을 쓰는 모던 스타일. 정리는 [design-system.md](design-system.md) | |

## 트러블슈팅

| 이슈 | 분야 | 발생일 | 상태 | 원인과 해결 | Notion |
| --- | --- | --- | --- | --- | --- |
| Claude 세션에서 저장소 push 거부 | 공통 | 2026-10-11 | 진행 중 | G-Mate 조직에 Claude GitHub 앱이 설치되지 않아 push 권한 없음. 조직 owner가 앱을 설치해야 함 | |
