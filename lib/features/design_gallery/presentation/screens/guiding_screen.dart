import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 길 찾기 - 이동 중. 화면 전체를 남색으로 채워 멀리서도 상태가 보이게 한다.
class GuidingScreen extends StatelessWidget {
  const GuidingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final place = samplePlaces.first;
    final text = context.textStyles;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navyLight, AppColors.navy],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GmStatusIndicator(
                  label: '이동 중',
                  type: GmStatusType.success,
                  onDark: true,
                ),
                const Spacer(),
                Text(
                  '${place.meta}로 가는 중',
                  style: text.bodyMedium?.copyWith(
                    color: AppColors.onNavyMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${place.name}로\n안내하고 있어요',
                  style: text.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SizedBox(
                  width: 420,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      color: Colors.white,
                      backgroundColor: Color(0x33FFFFFF),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '로봇을 따라와 주세요',
                  style: text.titleMedium?.copyWith(
                    color: AppColors.onNavyMuted,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: GmButton(
                    label: '안내 중지',
                    icon: Icons.stop_rounded,
                    variant: GmButtonVariant.danger,
                    size: GmButtonSize.large,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
