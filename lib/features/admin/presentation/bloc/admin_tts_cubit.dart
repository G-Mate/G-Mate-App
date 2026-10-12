import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/robot/robot_controller.dart';
import '../../../speech/domain/speech_settings.dart';
import '../../../speech/domain/speech_settings_repository.dart';
import 'admin_tts_state.dart';

/// 음성 설정: 목소리 값을 바꾸고 미리 들은 뒤 저장한다.
class AdminTtsCubit extends Cubit<AdminTtsState> {
  AdminTtsCubit({required this._robot, required this._settings})
    : super(const AdminTtsState());

  final RobotController _robot;
  final SpeechSettingsRepository _settings;

  Future<void> load() async {
    final settings = await _settings.load();
    emit(state.copyWith(isLoading: false, settings: settings));
  }

  void change(SpeechSettings settings) =>
      emit(state.copyWith(settings: settings));

  /// [기본값으로]: 화면의 값만 되돌린다. 저장은 따로 누른다.
  void reset() => emit(state.copyWith(settings: const SpeechSettings()));

  /// [이 설정으로 듣기].
  // TODO(speech): temi TTS 목소리 설정을 RobotController로 넘기면 지금 값으로 읽는다.
  Future<void> preview(String text) => _robot.speak(text);

  Future<void> save() async {
    await _settings.save(state.settings);
    emit(state.copyWith(saveCount: state.saveCount + 1));
  }
}
