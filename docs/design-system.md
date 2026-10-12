# 디자인 시스템

temi 머리 태블릿(가로 10인치대)을 허리 높이에서 서서 보고 누르는 키오스크 화면 기준입니다.
방향은 **깔끔한 모던 + 파랑 포인트**입니다. 연한 회색 바탕 위에 흰 면을 테두리·그림자 없이 올리고, 선명한 파랑 하나만 강조에 씁니다. 디자인 포인트는 **크기 대비**로 줍니다. 큰 제목 옆 작은 설명, 제목 위 파랑 막대 머리말, 섹션 번호와 가는 선, 카드 뒤에 크고 흐리게 깐 아이콘, 배경의 옅은 워터마크 글자를 모든 화면에 같은 리듬으로 씁니다. 학교 로고의 남색은 `navy`(`tertiary`)로 남겨 두었습니다.
글꼴은 아직 정해지지 않았습니다. 색을 조정할 때는 `app_colors.dart`만 바꾸면 됩니다.

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
| `lib/core/theme/app_colors.dart` | 파랑 `#3B5BDB`(포인트), 남색 `#14254A`, 회색 바탕 `#EEF1F6`·흰 면, 글자색, 성공·주의·위험, 워터마크 |
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
| `GmScaffold` | 화면 틀. 뒤로 가기·머리말·제목·오른쪽 동작, 여백 잡힌 본문, 하단 고정 버튼 줄 |
| `GmButton` | 버튼. `primary`/`secondary`/`outline`/`danger`, 크기 `large`/`medium`/`small`, 아이콘, `loading` |
| `GmMenuTile` | 홈 화면의 큰 메뉴. 흐린 큰 배경 아이콘 + 큰 제목 + 작은 설명. `emphasized`면 파랑 면, `onTap`이 없으면 '준비 중' 표시 |
| `GmPageHeading` | 화면 머리: 머리말(`GmEyebrow`) + 큰 제목 + 작은 부제 |
| `GmSectionHeader` | 섹션 머리: 번호 + 제목 + 가는 선 |
| `GmCard` | 흰 카드. 누를 수 있고 `selected` 표시 지원 (장소 카드 등) |
| `GmChoiceChip` | 카테고리 필터 |
| `GmTabs` | 글자 + 짧은 밑줄 탭 (층 전환 등) |
| `GmWatermark` | 배경에 크고 옅게 까는 장식 글자 |
| `GmStatusBanner` | 로봇 상태·안내 메시지 띠. `info`/`success`/`warning`/`danger` |
| `GmEmptyState` | 목록이 비었을 때 가운데 안내 |

새 공통 위젯은 `lib/core/widgets/`에 `gm_` 접두사로 만들고 `lib/core/design_system.dart`에서 export 합니다.
기능 하나에서만 쓰는 위젯은 그 기능의 `presentation/widgets/`에 둡니다.
