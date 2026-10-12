# 디자인 시스템

temi 머리 태블릿(가로 10인치대)을 허리 높이에서 서서 보고 누르는 키오스크 화면 기준입니다.
방향은 **절제된 모던**입니다. 화면의 큰 면은 학교 로고에서 가져온 남색 하나, 강조는 파랑 하나만 씁니다. 회색 바탕 위에 흰 카드를 테두리·그림자 없이 올리고, 장식은 메뉴 카드 뒤의 옅은 큰 아이콘 하나로만 제한합니다. 디자인 포인트는 장식이 아니라 남색 패널과 흰 영역의 화면 분할, 큰 제목과 작은 설명의 크기 대비로 만듭니다.
글꼴은 Pretendard(SIL OFL 1.1, `assets/fonts/pretendard/`)를 앱에 넣어 씁니다. 색을 조정할 때는 `app_colors.dart`만 바꾸면 됩니다.

## 쓰는 법

```dart
import 'package:g_mate/core/design_system.dart';
```

- 테마는 `AppTheme.light()`로 `lib/app/app.dart`에서 이미 적용되어 있습니다.
- 색은 `context.colors`(Material `ColorScheme`)와 `context.appColors`(성공·주의·위험 같은 의미 색)로 꺼냅니다. 화면에서 `Color(0x...)`를 직접 쓰지 않습니다.
- 글자는 `context.textStyles.titleLarge`처럼 테마 스타일을 씁니다. `fontSize`를 직접 쓰지 않습니다.
- 간격·크기는 `AppSpacing`, `AppRadius`, `AppSize` 상수를 씁니다.
- 앱을 띄운 뒤 `/design-gallery` 경로로 가면 토큰과 공통 위젯을 한 화면에서 볼 수 있습니다.

## 토큰

| 파일 | 내용 |
| --- | --- |
| `lib/core/theme/app_colors.dart` | 남색 `#13213F`(히어로 패널), 파랑 `#3360E0`(강조), 회색 바탕 `#F4F5F8`·흰 면, 글자색, 성공·주의·위험 |
| `lib/core/theme/app_typography.dart` | 글자 크기 체계. 본문 22, 버튼 26, 화면 제목 34, 환영 문구 44~64 |
| `lib/core/theme/app_dimens.dart` | 간격(4dp 단위), 모서리, 버튼 높이(88/64/48), 아이콘 크기, 애니메이션 시간, 그림자 |
| `lib/core/theme/app_semantic_colors.dart` | `ColorScheme`에 없는 의미 색 (`ThemeExtension`) |
| `lib/core/theme/app_theme.dart` | 위 토큰으로 만든 `ThemeData` (버튼, 카드, 칩, 입력창, 다이얼로그 등) |

## 키오스크 기준

- 방문객 화면의 누르는 요소는 최소 64dp, 주 버튼은 88dp입니다. 48dp(`GmButtonSize.small`)는 관리 모드에서만 씁니다.
- 본문은 22sp 이상입니다. 60cm~1m 떨어져서 읽을 수 있는 크기입니다.
- 화면 좌우 여백은 48dp입니다 (`GmScaffold`가 넣어 줍니다).
- 글꼴은 Pretendard 5가지 굵기(400~800)를 씁니다. 큰 글자일수록 자간을 크기의 -2~-3%로 좁힙니다.
- v1은 라이트 테마만 둡니다.

## 공통 위젯

| 위젯 | 용도 |
| --- | --- |
| `GmScaffold` | 화면 틀. 뒤로 가기·작은 머리말·제목·오른쪽 동작, 여백 잡힌 본문, 하단 고정 버튼 줄 |
| `GmButton` | 버튼. `primary`/`secondary`/`outline`/`danger`, 크기 `large`/`medium`/`small`, 아이콘, `loading` |
| `GmMenuTile` | 홈 화면의 큰 메뉴 카드. 옅은 큰 배경 아이콘 + 큰 제목 + 작은 설명 + 화살표 |
| `GmHeroPanel` | 화면 한쪽을 채우는 남색 패널. 머리말·큰 제목·부제·하단 위젯. 맨 위에는 `GmHeroBackButton`을 둘 수 있음 |
| `GmSplitLayout` | 왼쪽 남색 패널 + 오른쪽 본문 화면 틀 (홈, 장소 확인, 도착, PIN) |
| `GmPlaceCard` | 장소 카드: 사진(없으면 옅은 아이콘) + 이름 + 층·분류 |
| `GmCard` | 흰 카드. 누를 수 있고 `selected` 표시 지원 (장소 카드 등) |
| `GmChoiceChip` | 카테고리 필터 |
| `GmStatusBanner` | 로봇 상태·안내 메시지 띠. `info`/`success`/`warning`/`danger` |
| `GmStatusIndicator` | 점 + 짧은 글자로 된 작은 상태 표시 (남색 패널 위에서도 사용) |
| `GmEmptyState` | 목록이 비었을 때 가운데 안내 |

새 공통 위젯은 `lib/core/widgets/`에 `gm_` 접두사로 만들고 `lib/core/design_system.dart`에서 export 합니다.
기능 하나에서만 쓰는 위젯은 그 기능의 `presentation/widgets/`에 둡니다.

## 화면 시안

`/design-gallery` 맨 위의 버튼으로 열 수 있습니다. 예시 데이터로 그린 화면이고, 실제 기능을 만들 때 레이아웃을 가져간 뒤 시안은 지웁니다.

| 화면 | 구성 |
| --- | --- |
| 장소 선택 | 머리말 + 제목, 오른쪽 위 검색창, 분류 칩, 장소 카드 3열 |
| 장소 확인 | 왼쪽 남색 패널(층·분류, 장소 이름), 오른쪽 사진·설명·[다른 곳 고르기] [안내 시작] |
| 이동 중 | 화면 전체 남색, 큰 안내 문구와 흰 진행 막대, 오른쪽 아래 [안내 중지] |
| 도착·설명 | 왼쪽 남색 패널(도착한 장소), 오른쪽 문장 진행(2 / 4)과 지금 읽는 문장을 자막처럼 크게 |
| 관리 모드 PIN | 왼쪽 남색 패널, 오른쪽 입력 점 4개와 큰 숫자 키패드 |
| 장소 관리 | 장소 목록(아이콘, 이름, 층·분류·temi 키, 로봇 저장 상태), 줄마다 [미리 듣기] [이동 테스트] |
