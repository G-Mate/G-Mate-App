import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../theme/app_tokens.dart';
import 'gm_back_button.dart';
import 'gm_background.dart';
import 'gm_hero_panel.dart';

/// 키오스크 화면 공통 틀: 상단 제목줄(뒤로 가기, 제목, 오른쪽 동작) + 여백이 잡힌 본문
/// + 선택적인 하단 버튼 영역.
class GmScaffold extends StatelessWidget {
  const GmScaffold({
    super.key,
    required this.body,
    this.title,
    this.eyebrow,
    this.onBack,
    this.actions = const [],
    this.bottomBar,
    this.padded = true,
  });

  final Widget body;
  final String? title;

  /// 제목 위 작은 머리말 (예: '길 찾기', 'STEP 1').
  final String? eyebrow;

  /// null이 아니면 왼쪽에 큰 뒤로 가기 버튼을 보여 준다.
  final VoidCallback? onBack;
  final List<Widget> actions;

  /// 화면 아래에 고정할 버튼 줄 (예: [처음으로] [안내 시작]).
  final Widget? bottomBar;

  /// false면 본문 여백을 넣지 않는다 (지도처럼 화면을 꽉 채울 때).
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null || onBack != null || actions.isNotEmpty;

    return GmBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // 키오스크 화면은 키보드가 올라와도 배치를 밀어 올리지 않는다.
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasHeader)
                Padding(
                  // 뒤로 가기 버튼의 왼쪽 끝을 본문 여백 선에 맞춘다.
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.screenVertical,
                    AppSpacing.screenHorizontal,
                    0,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppSize.touchTargetMin,
                    ),
                    child: Row(
                      children: [
                        if (onBack != null)
                          GmBackButton(onPressed: onBack!)
                        else
                          const SizedBox.shrink(),
                        if (onBack != null)
                          const SizedBox(width: AppSpacing.lg),
                        if (title != null)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (eyebrow != null) ...[
                                  GmOverline(
                                    eyebrow!,
                                    color: context.appColors.textSecondary,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                ],
                                Text(
                                  title!,
                                  style: context.textStyles.headlineMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        else
                          const Spacer(),
                        for (final action in actions) ...[
                          const SizedBox(width: AppSpacing.sm),
                          action,
                        ],
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: padded
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.screenHorizontal,
                          hasHeader ? AppSpacing.lg : AppSpacing.screenVertical,
                          AppSpacing.screenHorizontal,
                          bottomBar == null
                              ? AppSpacing.screenVertical
                              : AppSpacing.md,
                        ),
                        child: body,
                      )
                    : body,
              ),
              if (bottomBar != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.md,
                    AppSpacing.screenHorizontal,
                    AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    border: Border(
                      top: BorderSide(color: context.colors.outlineVariant),
                    ),
                  ),
                  child: bottomBar,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
