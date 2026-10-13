import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import '../domain/tour.dart';

/// 코스 카드와 사진 자리에 쓰는 G-Mate 아이콘.
GmIcons tourIcon(Tour tour) => _byKey[tour.key] ?? GmIcons.tour;

const _byKey = {
  'first_visit': GmIcons.school,
  'classrooms': GmIcons.classroom,
  'full_tour': GmIcons.tour,
};

/// 코스 대표 사진. 없으면 아이콘 그림.
Widget tourPhoto(Tour tour) => switch (tour.imagePath) {
  final path? => Image(image: FileImage(File(path)), fit: BoxFit.cover),
  null => GmPlaceArt(icon: tourIcon(tour)),
};

/// 키로 들어온 코스가 없을 때 보여 주는 화면.
class TourNotFound extends StatelessWidget {
  const TourNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return GmScaffold(
      body: GmEmptyState(
        icon: Icons.wrong_location_outlined,
        title: '코스를 찾을 수 없어요',
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
