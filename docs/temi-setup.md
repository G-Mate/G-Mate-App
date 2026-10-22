# temi 실기 연결

temi에 앱을 올려 실제로 안내하기까지의 순서와, 코드에 아직 없는 것을 정리합니다. 실기에서 확인하면 이 문서를 고칩니다.

## 지금 되어 있는 것

- Kotlin `TemiBridge`가 temi SDK로 `goTo`, `stopMovement`, `speak`, `cancelAllTtsRequests`, `askQuestion`, `finishConversation`, `getLocations`, `saveLocation`, `deleteLocation`을 부르고, 준비·이동 상태·TTS 상태·알아들은 말·대화 상태·위치 목록 변경을 `gmate/robot/events`로 보냅니다.
- `onRobotReady(true)` 전에는 명령을 `NOT_READY` 오류로 거절합니다. 에뮬레이터에서 `USE_FAKE_ROBOT=false`로 켜면 홈에 '로봇 연결 안 됨'이 뜨고 앱은 정상 동작합니다.
- 장소 관리는 앱 장소 목록과 temi 위치 목록(`getLocations`)을 키로 맞춰 '로봇에 저장됨/로봇에 없음'을 보여 주고, [현재 위치 저장]은 로봇이 선 자리를 temi에 `saveLocation`한 뒤 같은 키로 앱 장소를 만듭니다.
- 매니페스트에 temi 스킬 메타데이터와 `OVERRIDE_NLU`가 있습니다.

## 연결 순서

1. temi 기본 앱에서 학교 층 지도를 만듭니다(Map 메뉴에서 로봇을 끌고 돌며 매핑). 충전 위치(`home base`)는 temi가 자동으로 둡니다.
2. 앱을 실기 모드로 빌드해 temi에 설치합니다.

   ```bash
   flutter build apk --release --dart-define=USE_FAKE_ROBOT=false
   adb connect <temi IP>:5555
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```

3. 앱을 켜고 홈 로봇 상태가 '준비됨'으로 바뀌는지 봅니다.
4. 관리 모드 → 장소 관리에서 로봇을 장소마다 데려가 [현재 위치 저장]을 누르고 영문 키(`science_lab`)와 한국어 이름을 넣습니다.
5. 장소 편집에서 사진, 분류, 층, 멘트, 본 설명을 채우고 [이동 테스트]로 도착하는지 봅니다.
6. 투어 관리에서 실제 장소로 코스를 다시 짭니다.

## 아직 없는 것 (실기 전에 정할 일)

| 항목 | 지금 | 할 일 |
| --- | --- | --- |
| temi 앱에서 저장한 위치 가져오기 | 앱 장소는 처음 넣은 예시 6개와 [현재 위치 저장]으로 만든 것뿐. temi 기본 앱에서 저장한 위치는 장소 관리에 나오지 않음 | 장소는 앱의 [현재 위치 저장]으로만 만들거나, `getLocations` 결과 중 앱에 없는 위치를 장소로 가져오는 기능을 추가. temi 위치 이름이 영문 소문자 키 규칙(`Place.keyPattern`)과 다르면 키 규칙도 함께 정해야 함 |
| 예시 장소·투어 | 첫 실행 때 과학실 등 예시 장소 6개와 코스 3개를 DB에 넣음. 실기에는 이 위치가 없어 고르면 이동 실패 | 실기에 처음 설치할 때 예시를 지우는 방법(관리 모드 삭제 또는 씨앗 데이터 비우기)을 정함 |
| 장소 선택 목록 | temi에 없는 장소도 방문객 목록에 나옴 | 로봇에 저장된 장소만 보여 줄지 정함 |
| 층 지도 | 이동 중 화면의 지도는 예시 평면도이고 진행률만 그림 | temi 지도 이미지·로봇 위치를 SDK로 받을 수 있는지 실기에서 확인 후 교체 |
| 여러 층 | temi 지도는 층마다 따로라 한 지도 안에서만 이동 | 한 층으로 시작할지, 층 이동 안내를 어떻게 할지 정함 |
| 음성 설정 적용 | 목소리·속도·높낮이·음량은 저장만 되고 `speak`에는 글만 넘김(명령 기다리는 시간만 쓰임) | temi TTS가 지원하는 항목을 실기에서 확인한 뒤 브리지로 넘기고, 지원하지 않는 항목은 화면에서 뺌 |
| 안내 뒤 복귀 | 안내·투어가 끝나도 로봇은 그 자리에 머묾 | 홈 위치로 돌아갈지, 얼마 뒤 돌아갈지 정함 |

## 실기에서 확인할 것

- `onRobotReady`, `goTo` 상태(start → going → complete, abort) 이벤트가 앱 화면 흐름과 맞는지
- 한국어 TTS와 `askQuestion` 음성 인식, `OVERRIDE_NLU`로 알아들은 말이 앱으로 오는지
- 학교 개요 웹 화면이 temi 태블릿에서 잘리지 않는지
