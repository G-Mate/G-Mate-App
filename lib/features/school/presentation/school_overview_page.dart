import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design_system.dart';
import 'bloc/school_overview_cubit.dart';
import 'widgets/school_document.dart';

/// 학교 개요. 왼쪽에 학교 사진 한 장을 걸어 두고, 오른쪽에 소개 문서를 둔다.
/// 문서만 위아래로 넘겨 읽고 사진은 그대로 있다.
class SchoolOverviewPage extends StatelessWidget {
  const SchoolOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolOverviewCubit, SchoolOverviewState>(
      builder: (context, state) {
        final info = state.info;
        if (state.isLoading || info == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return GmScaffold(
          eyebrow: '학교 개요',
          title: info.name,
          onBack: () => context.go(AppRoutes.home),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: switch (info.imagePath) {
                    final path? => Image(
                      image: FileImage(File(path)),
                      fit: BoxFit.cover,
                    ),
                    null => const GmPlaceArt(icon: GmIcons.school),
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.xxl),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: SchoolDocument(info.document),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
