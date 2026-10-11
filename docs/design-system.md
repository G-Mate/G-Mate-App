# 디자인 시스템

temi 머리 태블릿(가로 10인치대)을 허리 높이에서 서서 보고 누르는 키오스크 화면 기준입니다.
방향은 **파랑 계열 색 + 모던한 UI**입니다. 색은 학교 로고의 남색(#003366)을 참고해 더 맑은 톤으로 새로 골랐습니다. 테두리 대신 옅은 그림자와 연한 면 색으로 영역을 나누고, 모서리를 크게 둥글립니다.
학교 로고와 글꼴은 아직 정해지지 않았습니다. 색을 조정할 때는 `app_colors.dart`만 바꾸면 됩니다.

## 쓰는 법

```dart
import 'package:g_mate/core/design_system.dart';
```

- 테마는 `AppTheme.light()`로 `lib/app/app.dart`에서 이미 적용되어 있습니다.
- 브랜드 남색은 `context.colors.tertiary`로 꺼냅니다.
- 색은 `context.colors`(Material `ColorScheme`)와 `context.appColors`(성공·주의·위험 같은 의미 색)로 꺼냅니다. 화면에서 `Color(0x...)`를 직접 쓰지 않습니다.
- 글자는 `context.textStyles.titleLarge`처럼 테마 스타일을 씁니다. `fontSize`를 직접 쓰지 않습니다.
- 간격·크기는 `AppSpacing`, `AppRadius`, `AppSize` 상수를 씁니다.
- 앱을 띄운 뒤 `/design-gallery` 경로로 가면 토큰과 공통 위젯을 한 화면에서 볼 수 있습니다.

## 토큰

| 파일 | 내용 |
| --- | --- |
| `lib/core/theme/app_colors.dart` | 브랜드(남색 `#0B2A5B`, 파랑 `#2257D6`, 밝은 파랑 `#3D8FE6`), 푸른빛 회색 배경·표면, 글자색, 성공·주의·위험 |
| `lib/core/theme/app_typography.dart` | 글자 크기 체계. 본문 22, 버튼 26, 화면 제목 34, 환영 문구 44~64 |
| `lib/core/theme/app_dimens.dart` | 간격(4dp 단위), 모서리, 버튼 높이(88/64/48), 아이콘 크기, 애니메이션 시간, 그림자 |
| `lib/core/theme/app_semantic_colors.dart` | `ColorScheme`에 없는 의미 색 (`ThemeExtension`) |
| `lib/core/theme/app_theme.dart` | 위 토큰으로 만든 `ThemeData` (버튼, 카드, 칩, 입력창, 다이얼로그 등) |

## 키오스크 기준

- 방문객 화면의 누르는 요소는 최소 64dp, 주 버튼은 88dp입니다. 48dp(`GmButtonSize.small`)는 관리 모드에서만 씁니다.
- 본문은 22sp 이상입니다. 60cm~1m 떨어져서 읽을 수 있는 크기입니다.
- 화면 좌우 여백은 48dp입니다 (`GmScaffold`가 넣어 줍니다).
- 글꼴은 기기 기본 글꼴(Android는 Noto Sans CJK KR)을 씁니다. 전용 글꼴을 넣으려면 `pubspec.yaml`에 등록하고 `AppTypography.fontFamily`만 바꿉니다.
- v1은 라이트 테마만 둡니다.

## 공통 위젯

| 위젯 | 용도 |
| --- | --- |
| `GmScaffold` | 화면 틀. 뒤로 가기·제목·오른쪽 동작, 여백 잡힌 본문, 하단 고정 버튼 줄 |
| `GmButton` | 버튼. `primary`/`secondary`/`outline`/`danger`, 크기 `large`/`medium`/`small`, 아이콘, `loading` |
| `GmMenuTile` | 홈 화면의 큰 메뉴 ([길 찾기], [학교 투어]). `onTap`이 없으면 흐리게 표시 |
| `GmCard` | 흰 카드. 누를 수 있고 `selected` 표시 지원 (장소 카드 등) |
| `GmChoiceChip` | 카테고리 탭, 층 필터 |
| `GmStatusBanner` | 로봇 상태·안내 메시지 띠. `info`/`success`/`warning`/`danger` |
| `GmEmptyState` | 목록이 비었을 때 가운데 안내 |

새 공통 위젯은 `lib/core/widgets/`에 `gm_` 접두사로 만들고 `lib/core/design_system.dart`에서 export 합니다.
기능 하나에서만 쓰는 위젯은 그 기능의 `presentation/widgets/`에 둡니다.
