/// 앱 경로. 화면은 이 이름으로만 이동한다.
abstract final class AppRoutes {
  static const home = '/';

  // 길 찾기
  static const placeSelect = '/places';
  static String placeConfirm(String key) => '/places/$key';
  static String guiding(String key) => '/guide/$key';
  static String arrival(String key) => '/arrival/$key';

  // 학교 투어
  static const tourSelect = '/tours';
  static String tourConfirm(String key) => '/tours/$key';
  static String tourRun(String key) => '/tour-run/$key';
  static String tourDone(String key) => '/tour-done/$key';

  // 학교 개요
  static const schoolOverview = '/school';

  /// 학교 개요 링크를 앱 안에서 연다.
  static String schoolWeb({required String url, required String title}) => Uri(
    path: '/school/web',
    queryParameters: {'url': url, 'title': title},
  ).toString();

  // 관리 모드
  static const adminPin = '/admin';
  static const adminHome = '/admin/home';
  static const adminPlaces = '/admin/places';
  static String adminPlaceEdit(String key) => '/admin/places/$key';
  static const adminTts = '/admin/tts';
  static const adminPinChange = '/admin/pin-change';
  static const adminTours = '/admin/tours';
  static const adminTourNew = '/admin/tours/$newTourKey';
  static String adminTourEdit(String key) => '/admin/tours/$key';

  /// 코스 편집 경로에서 '새 코스'를 뜻하는 키.
  static const newTourKey = 'new';

  /// 개발용 디자인 시스템 미리보기.
  static const designGallery = '/design-gallery';
}
