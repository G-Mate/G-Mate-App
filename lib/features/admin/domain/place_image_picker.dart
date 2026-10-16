/// 장소·투어 코스 사진을 고르는 창구. 화면과 Cubit은 이 타입만 의존한다.
abstract interface class PlaceImagePicker {
  /// 기기 사진첩에서 사진 하나를 고르게 하고, 고른 파일 경로를 돌려준다.
  /// 고르지 않고 닫으면 null.
  Future<String?> pick();
}
