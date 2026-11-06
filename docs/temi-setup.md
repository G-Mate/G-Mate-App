# temi 실기 연결

temi에 앱을 올려 실제로 안내하기까지의 순서와, 코드에 아직 없는 것을 정리합니다. 실기에서 확인하면 이 문서를 고칩니다.

## 지금 되어 있는 것

- Kotlin `TemiBridge`가 temi SDK로 `goTo`, `stopMovement`, `speak`, `cancelAllTtsRequests`, `askQuestion`, `finishConversation`, `getLocations`, `saveLocation`, `deleteLocation`을 부르고, 준비·이동 상태·TTS 상태·알아들은 말·대화 상태·위치 목록 변경을 `gmate/robot/events`로 보냅니다.
- `onRobotReady(true)` 전에는 명령을 `NOT_READY` 오류로 거절합니다. 에뮬레이터에서 `USE_FAKE_ROBOT=false`로 켜면 홈에 '로봇 연결 안 됨'이 뜨고 앱은 정상 동작합니다.
- 장소 관리를 열면 temi 지도에 저장된 위치(`getLocations`) 중 앱에 없는 것을 위치 이름 그대로 새 장소로 가져옵니다(충전 위치 `home base`는 뺌). temi가 위치 변경을 알리면 다시 가져옵니다. 앱 장소와 temi 위치를 키로 맞춰 '로봇에 저장됨/로봇에 없음'을 보여 줍니다.
- [현재 위치 저장]은 로봇이 선 자리를 temi에 `saveLocation`하고 같은 키로 앱 장소를 만듭니다.
- 실기 빌드(`USE_FAKE_ROBOT=false`)는 첫 실행 때 예시 장소·코스를 넣지 않습니다.
- 매니페스트에 temi 스킬 메타데이터와 `OVERRIDE_NLU`가 있습니다.

## 1층 지도

temi는 층을 오가지 못해서 학교 배치도 중 **1층(본관 1F + 실습동 1F)만** 지도로 만듭니다. 앱의 예시 장소·투어 코스와 이동 중 화면의 평면도(`lib/core/floor_plan/first_floor_layout.dart`)도 1층 기준입니다. 충전 위치(`home base`)는 본관 가운데 출입문 앞 복도로 두는 것을 기준으로 평면도 출발점을 잡았습니다. 다른 곳에 두면 `FirstFloorLayout.homeBase`를 고칩니다.

temi에 위치를 저장할 때 아래 **위치 이름**을 쓰면, 장소 관리에서 가져올 때 한국어 이름·건물·분류·검색어·멘트가 자동으로 채워지고 평면도에 그 방까지 경로가 그려집니다. 한국어 이름(예: `교무실`)으로 저장해도 이름·멘트는 채워지지만, 평면도 경로는 영문 위치 이름일 때만 그려집니다.

| 위치 이름 | 장소 | 건물 |
| --- | --- | --- |
| `admin_office` | 행정실 | 본관 |
| `teachers_office` | 교무실 | 본관 |
| `principal_office` | 교장실 | 본관 |
| `vice_principal_office` | 교감실 | 본관 |
| `health_room` | 보건실(성고충상담실) | 본관 |
| `broadcast_room` | 방송실 | 본관 |
| `community_zone` | 커뮤니티존 | 본관 |
| `restroom_women` | 여자 화장실 | 본관 |
| `restroom_men` | 남자 화장실 | 본관 |
| `elevator` | 엘리베이터 | 본관 |
| `ai_service_lab` | AI서비스구현실습실 | 실습동 |
| `fitness_room` | 체력단련실 | 실습동 |
| `print_room` | 인쇄실 | 실습동 |

위치는 방 문 앞 복도에 로봇을 세우고 저장합니다. 멘트와 본 설명은 초안이라 장소 편집에서 고칩니다.

## 연결 순서

1. temi 기본 앱에서 학교 1층 지도를 만들고, 안내할 장소마다 위 표의 위치 이름으로 위치를 저장합니다. 충전 위치(`home base`)는 temi가 자동으로 둡니다.
2. 앱을 실기 모드로 빌드해 temi에 설치합니다.

   ```bash
   flutter build apk --release --dart-define=USE_FAKE_ROBOT=false
   adb connect <temi IP>:5555
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```

3. 앱을 켜고 홈 로봇 상태가 '준비됨'으로 바뀌는지 봅니다.
4. 관리 모드 → 장소 관리를 열면 temi에 저장한 위치가 장소로 들어와 있습니다. 앱에서 바로 더 저장하려면 로봇을 데려가 [현재 위치 저장]을 누릅니다.
5. 장소 편집에서 이름, 사진, 분류, 건물, 멘트, 본 설명을 채우고 [이동 테스트]로 도착하는지 봅니다.
6. 투어 관리에서 실제 장소로 코스를 다시 짭니다.

## 아직 없는 것 (실기 전에 정할 일)

| 항목 | 지금 | 할 일 |
| --- | --- | --- |
| temi에서 지운 위치 | temi에서 위치를 지워도 앱 장소는 남고 '로봇에 없음'으로 보임. 앱에는 장소 삭제가 없음 | 장소 관리에 삭제를 넣을지, 가져올 때 함께 지울지 정함 |
| 장소 선택 목록 | temi에 없는 장소도 방문객 목록에 나옴 | 로봇에 저장된 장소만 보여 줄지 정함 |
| 층 지도 | 이동 중 화면의 지도는 배치도로 그린 1층 평면도이고, 로봇 위치는 이동 진행률로 경로 위에 놓음 | temi 좌표를 SDK로 받을 수 있는지 실기에서 확인 후 실제 위치로 교체 |
| 다른 층 장소 | 1층만 안내. 다른 층 장소를 물으면 찾지 못함 (2026-11-06 결정: 지금은 넣지 않음) | 필요해지면 위치를 말로 알려 주거나 엘리베이터까지 안내할지 정함 |
| 음성 설정 적용 | 목소리·속도·높낮이·음량은 저장만 되고 `speak`에는 글만 넘김(명령 기다리는 시간만 쓰임) | temi TTS가 지원하는 항목을 실기에서 확인한 뒤 브리지로 넘기고, 지원하지 않는 항목은 화면에서 뺌 |
| 안내 뒤 복귀 | 안내·투어가 끝나도 로봇은 그 자리에 머묾 | 홈 위치로 돌아갈지, 얼마 뒤 돌아갈지 정함 |

## 실기에서 확인할 것

- `onRobotReady`, `goTo` 상태(start → going → complete, abort) 이벤트가 앱 화면 흐름과 맞는지
- 한국어 TTS와 `askQuestion` 음성 인식, `OVERRIDE_NLU`로 알아들은 말이 앱으로 오는지
- 학교 개요 웹 화면이 temi 태블릿에서 잘리지 않는지
