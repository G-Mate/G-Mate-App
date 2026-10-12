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
  int _tab = 0;

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
          Text(title, style: text.titleLarge),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );

    Widget swatch(String name, Color color, {Color? border}) => Column(
      children: [
        Container(
          width: 96,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: border ?? color),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(name, style: text.bodySmall),
      ],
    );

    return GmScaffold(
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
                swatch('navy', colors.tertiary),
                swatch('primary', colors.primary),
                swatch('container', colors.primaryContainer),
                swatch('secondary', colors.secondary),
                swatch(
                  'background',
                  AppColors.background,
                  border: colors.outlineVariant,
                ),
                swatch(
                  'surface',
                  colors.surface,
                  border: colors.outlineVariant,
                ),
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
                Text('안녕하세요, G-Mate예요', style: text.displaySmall),
                Text('과학실로 안내할게요', style: text.headlineMedium),
                Text('3층 · 교실', style: text.titleMedium),
                Text(
                  '실험 도구와 안전 장비가 갖춰진 교실입니다. 도착하면 설명을 들려 드려요.',
                  style: text.bodyLarge,
                ),
                Text(
                  '관리 모드 보조 설명',
                  style: text.bodySmall?.copyWith(
                    color: semantic.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          section(
            '메뉴 타일',
            SizedBox(
              height: 340,
              child: Row(
                children: [
                  Expanded(
                    child: GmMenuTile(
                      emphasized: true,
                      icon: Icons.near_me_rounded,
                      title: '길 찾기',
                      description: '가고 싶은 곳까지 데려다 드려요',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: GmMenuTile(
                      icon: Icons.tour_rounded,
                      title: '학교 투어',
                      description: '코스를 따라 학교를 둘러봐요',
                      onTap: () {},
                    ),
                  ),
                ],
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
                  icon: Icons.home_rounded,
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
            '밑줄 탭',
            GmTabs(
              labels: const ['1층', '2층', '3층'],
              selectedIndex: _tab,
              onSelected: (i) => setState(() => _tab = i),
            ),
          ),
          section(
            '워터마크',
            const SizedBox(
              height: 160,
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      left: 0,
                      child: GmWatermark('GSM', fontSize: 200),
                    ),
                  ],
                ),
              ),
            ),
          ),
          section(
            '상태 띠',
            const Column(
              children: [
                GmStatusBanner(
                  message: '과학실로 안내 중입니다',
                  icon: Icons.directions_walk_rounded,
                ),
                SizedBox(height: AppSpacing.sm),
                GmStatusBanner(
                  message: '과학실에 도착했어요',
                  type: GmStatusType.success,
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
              ],
            ),
          ),
          section(
            '카드와 빈 화면',
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GmCard(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('과학실', style: text.titleLarge),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '3층 · 교실',
                          style: text.bodyMedium?.copyWith(
                            color: semantic.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: GmCard(
                    selected: true,
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도서관', style: text.titleLarge),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '2층 · 편의시설',
                          style: text.bodyMedium?.copyWith(
                            color: semantic.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
