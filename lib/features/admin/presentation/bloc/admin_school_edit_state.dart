import 'package:equatable/equatable.dart';

import '../../../school/domain/school_info.dart';

class AdminSchoolEditState extends Equatable {
  const AdminSchoolEditState({
    this.isLoading = true,
    this.info,
    this.isSaved = false,
  });

  final bool isLoading;

  /// 고치는 중인 설정. 저장하기 전까지 저장소에는 반영되지 않는다.
  final SchoolInfo? info;
  final bool isSaved;

  /// 홈페이지 주소가 http(s)로 시작하는 웹 주소인지.
  bool get isUrlValid {
    final uri = Uri.tryParse(info?.homepageUrl.trim() ?? '');
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  AdminSchoolEditState copyWith({SchoolInfo? info, bool? isSaved}) =>
      AdminSchoolEditState(
        isLoading: isLoading,
        info: info ?? this.info,
        isSaved: isSaved ?? this.isSaved,
      );

  @override
  List<Object?> get props => [isLoading, info, isSaved];
}
