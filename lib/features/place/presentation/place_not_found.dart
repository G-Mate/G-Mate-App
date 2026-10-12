import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';

/// 키로 들어온 장소가 없을 때 보여 주는 화면.
class PlaceNotFound extends StatelessWidget {
  const PlaceNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return GmScaffold(
      body: GmEmptyState(
        icon: Icons.wrong_location_outlined,
        title: '장소를 찾을 수 없어요',
        action: GmButton(
          label: '처음으로',
          icon: Icons.home_outlined,
          variant: GmButtonVariant.outline,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
    );
  }
}
