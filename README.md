# G-Mate

temi 로봇 위에서 동작하는 학교 안내 Android 앱입니다. 방문객에게 길 찾기와 학교 투어를 제공하고, 교사·관리자는 장소와 투어 코스를 관리합니다.

> 초기 구상 단계입니다. 개요는 개발이 진행되면서 다듬습니다.

## 기술 스택

- Flutter (Dart) · Clean Architecture · flutter_bloc
- get_it, go_router (검토 중 기본값)
- temi SDK: Kotlin 네이티브 브리지 + MethodChannel/EventChannel

## 시작하기

```bash
flutter pub get
flutter run                                   # FakeRobotController로 실행 (기본값)
flutter run --dart-define=USE_FAKE_ROBOT=false  # 실기 temi 브리지 사용
```

```bash
flutter analyze
flutter test
```

## 문서

- [Git 컨벤션](docs/conventions/git.md)
- [프로젝트 규칙](docs/conventions/project-rules.md)
- [작업 기록](docs/worklog.md) (Notion으로 옮기기 전 임시 기록)
- [설계안](https://claude.ai/code/artifact/4587d550-0734-4a9e-b9e7-7872be0943ec)
