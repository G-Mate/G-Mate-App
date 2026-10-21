# Git 컨벤션

G-Mate 저장소에서 브랜치, 커밋, PR을 다루는 규칙입니다. 사람과 Claude 모두 이 문서를 따릅니다.

## 브랜치 전략

`main`과 `develop` 두 브랜치를 기준으로 두고, 모든 작업은 짧게 사는 작업 브랜치에서 해서 PR로 합칩니다.

- `main`: 배포(실기 설치)할 수 있는 상태만 둡니다. `develop`을 PR로 합칠 때만 바뀝니다.
- `develop`: 다음 배포에 들어갈 작업을 모으는 곳입니다. 항상 빌드되는 상태를 유지합니다.
- 작업 브랜치: `develop`에서 만들고, PR은 `develop`으로 올립니다. 합친 뒤에는 삭제합니다.
- 두 기준 브랜치 모두 직접 push하지 않고 PR로만 합칩니다.
- PR을 다른 작업 브랜치 위에 쌓지 않습니다. 앞 PR이 합쳐진 뒤 `develop`에서 새로 만들거나 `develop` 위로 rebase합니다.

### 배포

1. `develop` → `main` PR을 올립니다. 제목은 `chore(release): v0.1.0`처럼 버전을 적습니다.
2. 이 PR만 Squash 대신 **Create a merge commit**으로 합칩니다. 두 브랜치 기록이 어긋나지 않게 하려는 것입니다.
3. 합친 뒤 `main`에 버전 태그를 붙입니다.

### 이슈 먼저

모든 작업은 GitHub 이슈에서 시작합니다. 이슈를 먼저 만들고, 그 번호로 브랜치를 만듭니다.

- 이슈 제목은 무엇을 할지 한 줄로 씁니다. 예: `장소 목록 화면 만들기`
- 이슈 하나 = 브랜치 하나 = PR 하나가 기본입니다.
- 혼자 작업하는 동안은 브랜치를 잘게 나누지 않습니다. 열려 있는 작업 PR이 있으면 이어지는 요청과 작은 수정도 그 브랜치에 올리고, 그 PR이 합쳐진 뒤에 새 브랜치를 만듭니다.

### 브랜치 이름

```
<타입>/<이슈 번호>-<짧은-설명>
```

- 타입은 아래 커밋 타입과 같은 목록을 씁니다 (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `build`, `ci`, `style`, `perf`).
- 이슈 번호는 `#` 없이 숫자만 씁니다.
- 설명은 영어 소문자와 하이픈(kebab-case)으로, 3~5단어 안쪽으로 씁니다.

예시

```
feat/12-place-list-screen
feat/15-temi-bridge-goto
fix/21-tour-abort-retry
docs/3-git-convention
chore/1-project-setup
```

## 커밋 메시지

[Conventional Commits](https://www.conventionalcommits.org/ko/v1.0.0/) 형식을 따릅니다.

```
<타입>(<범위>): <제목>

<본문 (선택)>

<꼬리말 (선택)>
```

### 타입

| 타입 | 언제 |
| --- | --- |
| `feat` | 사용자가 느끼는 새 기능 |
| `fix` | 버그 수정 |
| `docs` | 문서만 변경 |
| `refactor` | 동작 변화 없는 코드 구조 변경 |
| `test` | 테스트 추가·수정 |
| `chore` | 빌드·설정·의존성 등 기타 잡무 |
| `build` | 빌드 시스템, Gradle, pubspec 의존성 변경 |
| `ci` | GitHub Actions 등 CI 설정 |
| `style` | 포맷, 세미콜론 등 의미 없는 변경 |
| `perf` | 성능 개선 |

### 범위

선택 사항이며, 바뀐 영역을 적습니다. 자주 쓰는 범위는 다음과 같습니다.

| 범위 | 영역 |
| --- | --- |
| `ui` | 화면, 위젯, 테마 |
| `robot` | `RobotController`, Kotlin temi 브리지, 플랫폼 채널 |
| `data` | DB, Repository, 모델 |
| `guide` | 길 찾기 |
| `tour` | 투어(안내 경로) |
| `place` | 장소(공간 지정) |
| `admin` | 관리 모드 |
| `speech` | 설명 음성, TTS 큐 |
| `deps` | 의존성 |

### 제목 규칙

- 한국어로 씁니다. 코드 이름(클래스, 메서드)은 그대로 씁니다.
- 50자 이내, 끝에 마침표를 찍지 않습니다.
- "~추가", "~수정"처럼 무엇을 했는지 명사형으로 끝냅니다.

### 본문 규칙

- 제목과 한 줄 띄우고 씁니다.
- "무엇을"보다 "왜"를 적습니다. 한 줄 72자 안쪽에서 줄바꿈합니다.

### 예시

```
feat(robot): FakeRobotController에 goTo 이동 시뮬레이션 추가

로봇 지도가 아직 없어서 화면과 투어 로직을 에뮬레이터에서
개발하려면 이동 상태 이벤트를 흉내 내야 한다.
```

```
fix(tour): ABORT 후 재시도 횟수가 초기화되지 않던 문제 수정
```

```
docs: Git 컨벤션 문서 추가
```

### 커밋 단위

- 한 커밋에는 한 가지 목적만 담습니다. 포맷 변경과 기능 변경을 섞지 않습니다.
- 커밋마다 빌드가 깨지지 않게 합니다.
- 커밋 꼬리말에 관련 이슈를 `Refs: #12`처럼 적을 수 있습니다 (선택).
- 커밋 템플릿: `git config commit.template .gitmessage` 로 저장소의 [.gitmessage](../../.gitmessage)를 쓸 수 있습니다.

## Pull Request

- 제목은 커밋 메시지 제목과 같은 형식(`<타입>(<범위>): <제목>`)으로 씁니다.
- 본문은 [PR 템플릿](../../.github/pull_request_template.md)을 채웁니다.
- 하나의 PR은 하나의 기능·수정만 다룹니다. 크면 나눕니다.
- 본문에 `Closes #<이슈 번호>`를 적습니다. GitHub은 저장소 기본 브랜치에 합쳐질 때만 이슈를 자동으로 닫으므로, 기본 브랜치가 `main`인 동안은 `develop`에 합친 뒤 이슈를 직접 닫습니다.
- 머지 전 확인: `flutter analyze` 경고 없음, `flutter test` 통과, 작업 기록([docs/worklog.md](../worklog.md)) 갱신.
- 머지 방식은 **Squash and merge**입니다. 합쳐진 커밋 제목은 PR 제목을 그대로 씁니다.
- 머지 후 작업 브랜치는 삭제합니다.

## 태그와 버전

- 버전은 `pubspec.yaml`의 `version`을 기준으로 `MAJOR.MINOR.PATCH+BUILD` 형식을 씁니다.
- 실기 배포 등 의미 있는 시점에 `v0.1.0` 같은 태그를 `main`에 붙입니다.

## 하지 않는 것

- `main`, `develop`에 직접 push, force push
- 다른 사람 브랜치의 히스토리 재작성(rebase 후 force push)
- 비밀값(keystore, API 키, `.env`)을 커밋하는 것. 필요한 파일은 `.gitignore`에 넣습니다.
