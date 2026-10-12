import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';
import 'sample_places.dart';

/// 시안: 길 찾기 - 장소 선택.
class PlaceSelectScreen extends StatefulWidget {
  const PlaceSelectScreen({super.key});

  @override
  State<PlaceSelectScreen> createState() => _PlaceSelectScreenState();
}

class _PlaceSelectScreenState extends State<PlaceSelectScreen> {
  static const _categories = ['전체', '교실', '행정실', '편의시설'];
  String _category = _categories.first;

  @override
  Widget build(BuildContext context) {
    final places = _category == '전체'
        ? samplePlaces
        : samplePlaces.where((p) => p.category == _category).toList();

    return GmScaffold(
      eyebrow: '길 찾기',
      title: '어디로 갈까요?',
      onBack: () => Navigator.of(context).maybePop(),
      actions: [
        SizedBox(
          width: 360,
          child: TextField(
            style: context.textStyles.bodyMedium,
            decoration: const InputDecoration(
              hintText: '장소 이름으로 찾기',
              prefixIcon: Icon(Icons.search_rounded, size: AppSize.iconMd),
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.lg,
              childAspectRatio: 1.15,
              children: [
                for (final p in places)
                  GmPlaceCard(
                    name: p.name,
                    meta: p.meta,
                    icon: p.icon,
                    fillHeight: true,
                    onTap: () {},
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
