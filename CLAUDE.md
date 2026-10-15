# G-Mate 작업 규칙 (Claude용)

작업 전에 아래 문서를 읽고 그대로 따릅니다.

- Git 규칙: `docs/conventions/git.md` (이슈를 먼저 만들고 `<타입>/<이슈 번호>-<설명>` 브랜치, PR 본문에 `Closes #번호`, Conventional Commits 한국어 제목, 작업 브랜치는 `develop`에서 만들고 PR도 `develop`으로, PR은 Squash merge, `main`·`develop` 직접 push 금지)
- 코드 규칙: `docs/conventions/project-rules.md` (Clean Architecture + flutter_bloc, 위젯은 Bloc만 의존, temi 호출은 `RobotController`로만)
- 작업이 끝나면 `docs/worklog.md`에 완료한 작업만 추가합니다. 트러블슈팅은 실제로 겪은 문제만 적습니다. 항목에 ID를 붙이지 않습니다.
- PR 전에 `dart format lib test`, `flutter analyze`, `flutter test`를 돌립니다.
