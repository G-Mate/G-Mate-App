import 'package:image_picker/image_picker.dart';

import '../domain/place_image_picker.dart';

/// 기기 사진첩(Android 사진 선택기)에서 장소 사진을 고른다.
class GalleryPlaceImagePicker implements PlaceImagePicker {
  GalleryPlaceImagePicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 키오스크 화면에 맞춰 줄여 저장하는 최대 가로 크기 (px).
  static const _maxWidth = 1920.0;
  static const _quality = 85;

  @override
  Future<String?> pick() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _maxWidth,
      imageQuality: _quality,
    );
    return file?.path;
  }
}
