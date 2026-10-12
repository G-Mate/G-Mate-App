/// 앱 경로. 화면은 이 이름으로만 이동한다.
abstract final class AppRoutes {
  static const home = '/';

  // 길 찾기
  static const placeSelect = '/places';
  static String placeConfirm(String key) => '/places/$key';
  static String guiding(String key) => '/guide/$key';
  static String arrival(String key) => '/arrival/$key';

  // 관리 모드
  static const adminPin = '/admin';
  static const adminPlaces = '/admin/places';
  static String adminPlaceEdit(String key) => '/admin/places/$key';
  static const adminTts = '/admin/tts';

  /// 개발용 디자인 시스템 미리보기.
  static const designGallery = '/design-gallery';
}
