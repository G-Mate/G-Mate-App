import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/design_system.dart';
import '../../../guide/presentation/widgets/keep_all_text.dart';
import '../../domain/school_info.dart';

/// 학교 개요 페이지. 블록을 웹 페이지처럼 위에서 아래로 그리고, 맨 아래에
/// 만든 사람들을 작게 둔다. 방문객 화면과 관리 모드 미리 보기가 같이 쓴다.
class SchoolPageView extends StatelessWidget {
  const SchoolPageView({super.key, required this.info, this.controller});

  final SchoolInfo info;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: [
        for (final (i, block) in info.blocks.indexed)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : _gapBefore(block)),
            child: _Block(block: block),
          ),
        const SizedBox(height: AppSpacing.xxl),
        _Credits(info: info),
      ],
    );
  }

  /// 소제목 앞은 넓게 띄워 묶음이 나뉘어 보이게 한다.
  static double _gapBefore(SchoolBlock block) =>
      block.type == SchoolBlockType.heading ||
          block.type == SchoolBlockType.hero
      ? AppSpacing.xxxl
      : AppSpacing.lg;
}

class _Block extends StatelessWidget {
  const _Block({required this.block});

  final SchoolBlock block;

  @override
  Widget build(BuildContext context) => switch (block.type) {
    SchoolBlockType.hero => _Hero(block: block),
    SchoolBlockType.heading => _Heading(block: block),
    SchoolBlockType.text => _Paragraphs(
      block.body,
      style: context.textStyles.bodyLarge?.copyWith(
        color: context.appColors.textSecondary,
      ),
    ),
    SchoolBlockType.image => _Image(block: block),
    SchoolBlockType.cards => _Cards(cards: block.cards),
    SchoolBlockType.link => _Link(block: block),
  };
}

/// 큰 배너: 사진(없으면 남색 면) 위에 큰 문구를 가운데 둔다.
class _Hero extends StatelessWidget {
  const _Hero({required this.block});

  final SchoolBlock block;

  static const _height = 360.0;

  /// 사진 위 글자가 읽히도록 덮는 어둠.
  static const _shadeAlpha = 0.45;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final path = block.imagePath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (path != null)
              Image(image: FileImage(File(path)), fit: BoxFit.cover)
            else
              ColoredBox(color: context.colors.primaryContainer),
            if (path != null)
              ColoredBox(color: Colors.black.withValues(alpha: _shadeAlpha)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (block.title.isNotEmpty)
                    _Paragraphs(
                      block.title,
                      alignment: WrapAlignment.center,
                      style: text.headlineMedium?.copyWith(color: Colors.white),
                    ),
                  if (block.body.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _Paragraphs(
                      block.body,
                      alignment: WrapAlignment.center,
                      style: text.displaySmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.block});

  final SchoolBlock block;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (block.title.isNotEmpty)
          _Paragraphs(block.title, style: text.headlineSmall),
        if (block.body.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          _Paragraphs(
            block.body,
            style: text.bodyLarge?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.block});

  final SchoolBlock block;

  static const _aspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final path = block.imagePath;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: path != null
                ? Image(image: FileImage(File(path)), fit: BoxFit.cover)
                : const GmPlaceArt(icon: GmIcons.school),
          ),
        ),
        if (block.body.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          _Paragraphs(
            block.body,
            alignment: WrapAlignment.center,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// 카드 묶음: 넓으면 세 줄, 좁으면 두 줄로 놓는다.
class _Cards extends StatelessWidget {
  const _Cards({required this.cards});

  final List<SchoolCard> cards;

  static const _wideWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= _wideWidth ? 3 : 2;
        final width =
            (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final card in cards)
              Container(
                width: width,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: context.colors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (card.emoji.isNotEmpty) ...[
                      Text(card.emoji, style: text.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    if (card.title.isNotEmpty)
                      _Paragraphs(card.title, style: text.titleMedium),
                    if (card.body.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      _Paragraphs(
                        card.body,
                        style: text.bodySmall?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// 링크: 키오스크에서는 누를 수 없으니 QR 코드와 주소를 보여 준다.
class _Link extends StatelessWidget {
  const _Link({required this.block});

  final SchoolBlock block;

  static const _qrSize = 120.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          // QR은 흰 바탕이어야 휴대폰이 잘 읽는다.
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: block.url.isEmpty
                ? const SizedBox.square(dimension: _qrSize)
                : QrImageView(
                    data: block.url,
                    size: _qrSize,
                    padding: EdgeInsets.zero,
                  ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.title.isEmpty ? '링크' : block.title,
                  style: text.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '휴대폰 카메라로 QR 코드를 찍어 보세요',
                  style: text.bodySmall?.copyWith(
                    color: semantic.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  block.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 페이지 맨 아래: 선 하나와 만든 사람들 한 줄.
class _Credits extends StatelessWidget {
  const _Credits({required this.info});

  final SchoolInfo info;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    final label = text.bodySmall?.copyWith(color: semantic.textSecondary);
    final value = text.bodySmall?.copyWith(color: context.colors.onSurface);
    final parts = [
      if (info.teamName.isNotEmpty) ('만든 팀', info.teamName),
      if (info.developer.isNotEmpty) ('개발', info.developer),
      if (info.planner.isNotEmpty) ('기획', info.planner),
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Wrap(
        spacing: AppSpacing.xl,
        runSpacing: AppSpacing.xs,
        children: [
          for (final (role, names) in parts)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$role  ', style: label),
                  TextSpan(text: names, style: value),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 줄을 바꾼 자리에서 줄을 바꾸고, 한 줄 안에서는 단어 단위로만 줄바꿈한다.
class _Paragraphs extends StatelessWidget {
  const _Paragraphs(
    this.text, {
    this.style,
    this.alignment = WrapAlignment.start,
  });

  final String text;
  final TextStyle? style;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment == WrapAlignment.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.stretch,
      children: [
        for (final line in text.split('\n'))
          if (line.trim().isNotEmpty)
            KeepAllText(line.trim(), style: style, alignment: alignment),
      ],
    );
  }
}
