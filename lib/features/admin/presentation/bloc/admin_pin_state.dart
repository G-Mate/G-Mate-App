import 'package:equatable/equatable.dart';

class AdminPinState extends Equatable {
  const AdminPinState({
    required this.length,
    this.entered = '',
    this.isWrong = false,
    this.isVerified = false,
  });

  /// PIN 자릿수.
  final int length;
  final String entered;

  /// 방금 넣은 PIN이 틀렸는지. 다음 입력에서 지운다.
  final bool isWrong;
  final bool isVerified;

  AdminPinState copyWith({String? entered, bool? isWrong, bool? isVerified}) =>
      AdminPinState(
        length: length,
        entered: entered ?? this.entered,
        isWrong: isWrong ?? this.isWrong,
        isVerified: isVerified ?? this.isVerified,
      );

  @override
  List<Object?> get props => [length, entered, isWrong, isVerified];
}
