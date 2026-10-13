import 'package:flutter/material.dart';

import '../../../core/design_system.dart';

/// 디자인 시스템 미리보기 화면. 개발 중 토큰과 공통 위젯을 한눈에 확인할 때 쓴다.
class DesignGalleryPage extends StatefulWidget {
  const DesignGalleryPage({super.key});

  @override
  State<DesignGalleryPage> createState() => _DesignGalleryPageState();
}

class _DesignGalleryPageState extends State<DesignGalleryPage> {
  static const _categories = ['전체', '교실', '행정실', '편의시설'];
  String _category = _categories.first;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final colors = context.colors;
    final semantic = context.appColors;

    Widget section(String title, Widget child) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: text.titleSmall?.copyWith(color: semantic.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );

    Widget swatch(String name, Color color) => Column(
      children: [
        Container(
          width: 96,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: colors.outlineVariant),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(name, style: text.bodySmall),
      ],
    );

    Widget placeCard(String name, String info, {bool selected = false}) =>
        GmCard(
          selected: selected,
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: text.titleLarge),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                info,
                style: text.bodySmall?.copyWith(color: semantic.textSecondary),
              ),
            ],
          ),
        );

    return GmScaffold(
      eyebrow: '개발용',
      title: '디자인 시스템',
      onBack: Navigator.of(context).canPop()
          ? () => Navigator.of(context).pop()
          : null,
      body: ListView(
        children: [
          section(
            '색',
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                swatch('navy', AppColors.navy),
                swatch('primary', colors.primary),
                swatch('container', colors.primaryContainer),
                swatch('background', AppColors.background),
                swatch('surface', colors.surface),
                swatch('success', semantic.success),
                swatch('warning', semantic.warning),
                swatch('danger', semantic.danger),
              ],
            ),
          ),
          section(
            '글자',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('무엇을 도와드릴까요?', style: text.displaySmall),
                Text('과학실로 안내할게요', style: text.headlineLarge),
                Text('과학실', style: text.titleLarge),
                Text(
                  '실험 도구와 안전 장비가 갖춰진 교실입니다. 도착하면 설명을 들려 드려요.',
                  style: text.bodyLarge,
                ),
                Text(
                  '3층 · 교실',
                  style: text.bodySmall?.copyWith(
                    color: semantic.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          section(
            '히어로 패널 + 메뉴 카드',
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: SizedBox(
                height: 420,
                child: ColoredBox(
                  color: AppColors.background,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(
                        flex: 5,
                        child: GmHeroPanel(
                          overline: '광주소프트웨어마이스터고등학교',
                          title: '무엇을\n도와드릴까요?',
                          footer: GmStatusIndicator(
                            label: '로봇 준비 완료',
                            type: GmStatusType.success,
                            onDark: true,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: GmMenuTile(
                                  icon: GmIcons.navigate,
                                  title: '길 찾기',
                                  description: '가고 싶은 곳까지 데려다 드려요',
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Expanded(
                                child: GmMenuTile(
                                  icon: GmIcons.tour,
                                  title: '학교 투어',
                                  description: '코스를 따라 학교를 둘러봐요',
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          section(
            '버튼',
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                GmButton(
                  label: '안내 시작',
                  icon: Icons.play_arrow_rounded,
                  size: GmButtonSize.large,
                  onPressed: () {},
                ),
                GmButton(
                  label: '다시 듣기',
                  icon: Icons.replay_rounded,
                  variant: GmButtonVariant.secondary,
                  onPressed: () {},
                ),
                GmButton(
                  label: '처음으로',
                  icon: Icons.home_outlined,
                  variant: GmButtonVariant.outline,
                  onPressed: () {},
                ),
                GmButton(
                  label: '안내 중지',
                  icon: Icons.stop_rounded,
                  variant: GmButtonVariant.danger,
                  onPressed: () {},
                ),
                const GmButton(label: '비활성', onPressed: null),
                GmButton(label: '저장 중', loading: true, onPressed: () {}),
                GmButton(
                  label: '관리용',
                  size: GmButtonSize.small,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          section(
            '선택 칩',
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final c in _categories)
                  GmChoiceChip(
                    label: c,
                    selected: c == _category,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
          ),
          section(
            '상태',
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GmStatusBanner(
                  message: '과학실로 안내 중입니다',
                  icon: Icons.directions_walk_rounded,
                ),
                SizedBox(height: AppSpacing.sm),
                GmStatusBanner(
                  message: '잠시만요, 길을 비켜 주세요',
                  type: GmStatusType.warning,
                ),
                SizedBox(height: AppSpacing.sm),
                GmStatusBanner(
                  message: '이동하지 못했어요. 관리자에게 알려 주세요',
                  type: GmStatusType.danger,
                ),
                SizedBox(height: AppSpacing.lg),
                GmStatusIndicator(
                  label: '로봇 준비 완료',
                  type: GmStatusType.success,
                ),
              ],
            ),
          ),
          section(
            '카드와 빈 화면',
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: placeCard('과학실', '3층 · 교실')),
                const SizedBox(width: AppSpacing.lg),
                Expanded(child: placeCard('도서관', '2층 · 편의시설', selected: true)),
                const SizedBox(width: AppSpacing.lg),
                const Expanded(
                  child: GmCard(
                    child: GmEmptyState(
                      title: '찾는 장소가 없어요',
                      message: '다른 이름으로 검색해 보세요',
                    ),
                  ),
                ),
              ],
            ),
          ),
          section(
            '입력',
            const SizedBox(
              width: 480,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '장소 이름',
                  hintText: '예: 과학실',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
