import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// [현재 위치 저장]에서 받는 새 장소 이름과 로봇 장소 키.
typedef NewPlace = ({String name, String key});

/// 새 장소의 표시 이름과 temi 장소 키를 받는 창.
class NewPlaceDialog extends StatefulWidget {
  const NewPlaceDialog({super.key, required this.validateKey});

  /// 키에 문제가 있으면 안내 문구, 괜찮으면 null.
  final String? Function(String key) validateKey;

  @override
  State<NewPlaceDialog> createState() => _NewPlaceDialogState();
}

class _NewPlaceDialogState extends State<NewPlaceDialog> {
  static const _width = 480.0;

  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _key = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _key.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context)
        .pop<NewPlace>((name: _name.text.trim(), key: _key.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return GmDenseTheme(
      child: AlertDialog(
        title: const Text('현재 위치 저장'),
        content: SizedBox(
          width: _width,
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '로봇이 지금 서 있는 자리를 새 장소로 저장해요.',
                  style: text.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _name,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: '표시 이름'),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? '이름을 적어 주세요' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _key,
                  decoration: const InputDecoration(
                    labelText: '로봇 장소 키',
                    hintText: '예: science_lab',
                  ),
                  validator: (v) => widget.validateKey((v ?? '').trim()),
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          GmButton(
            label: '취소',
            size: GmButtonSize.small,
            variant: GmButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(),
          ),
          GmButton(
            label: '저장',
            icon: Icons.check_rounded,
            size: GmButtonSize.small,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
