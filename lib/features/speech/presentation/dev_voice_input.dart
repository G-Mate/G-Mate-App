import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system.dart';
import 'bloc/dev_voice_cubit.dart';

/// 개발용 빌드에서 화면 왼쪽 아래에 두는 작은 마이크 버튼.
/// 누르면 할 말을 글로 넣어 음성 명령을 흉내 낸다.
class DevVoiceInput extends StatelessWidget {
  const DevVoiceInput({super.key, required this.navigatorKey});

  /// 앱 화면 위에 입력 창을 띄우기 위한 Navigator.
  final GlobalKey<NavigatorState> navigatorKey;

  static const _buttonSize = 40.0;
  static const _buttonOpacity = 0.6;

  Future<void> _open(BuildContext context) async {
    final cubit = context.read<DevVoiceCubit>();
    final dialogContext = navigatorKey.currentContext;
    if (dialogContext == null) return;
    final text = await showDialog<String>(
      context: dialogContext,
      builder: (_) => const _DevVoiceDialog(),
    );
    // 창이 다 닫힌 뒤에 보내서, 명령으로 화면이 바뀌어도 창과 겹치지 않게 한다.
    if (text != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => cubit.hear(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.xs,
      bottom: AppSpacing.xs,
      child: Opacity(
        opacity: _buttonOpacity,
        child: SizedBox.square(
          dimension: _buttonSize,
          // 앱 Navigator 바깥이라 Overlay가 필요한 툴팁·FAB 대신 단순한 버튼을 쓴다.
          child: Material(
            color: context.colors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _open(context),
              child: Icon(
                Icons.mic_none_rounded,
                color: context.colors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DevVoiceDialog extends StatefulWidget {
  const _DevVoiceDialog();

  @override
  State<_DevVoiceDialog> createState() => _DevVoiceDialogState();
}

class _DevVoiceDialogState extends State<_DevVoiceDialog> {
  static const _dialogWidth = 480.0;

  /// 자주 쓰는 명령. 누르면 바로 보낸다.
  static const _quick = [
    '길 찾기',
    '장소 목록',
    '과학실',
    '안내 시작',
    '취소',
    '안내 중지',
    '설명 듣기',
    '마침',
  ];

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('음성 명령 흉내 (개발용)'),
      // 키보드가 올라와도 넘치지 않게 스크롤한다. 자주 쓰는 명령은 바로 누른다.
      content: SizedBox(
        width: _dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: '로봇에게 할 말'),
                onSubmitted: (v) => Navigator.pop(context, v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final q in _quick)
                    ActionChip(
                      label: Text(q),
                      onPressed: () => Navigator.pop(context, q),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('말하기'),
        ),
      ],
    );
  }
}
