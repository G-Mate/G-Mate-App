import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/place_image_picker.dart';

/// 기기 사진첩(Android 사진 선택기)에서 장소 사진을 고른다.
///
/// 고른 사진은 앱 문서 폴더(`place_photos/`)로 복사해 그 경로를 돌려준다.
/// image_picker가 주는 경로는 캐시라서 앱을 다시 켜면 지워질 수 있다.
class GalleryPlaceImagePicker implements PlaceImagePicker {
  GalleryPlaceImagePicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 키오스크 화면에 맞춰 줄여 저장하는 최대 가로 크기 (px).
  static const _maxWidth = 1920.0;
  static const _quality = 85;
  static const _photoDir = 'place_photos';

  @override
  Future<String?> pick() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _maxWidth,
      imageQuality: _quality,
    );
    if (file == null) return null;

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _photoDir));
    await dir.create(recursive: true);
    final name =
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}';
    final saved = await File(file.path).copy(p.join(dir.path, name));
    return saved.path;
  }
}
