import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/routes.dart';
import '../../../../core/design_system.dart';
import '../../../guide/presentation/widgets/keep_all_text.dart';
import '../../domain/school_page.dart';

/// 학교 개요 페이지. 블록을 웹 페이지처럼 위에서 아래로 그리고, 맨 아래에
/// 만든 팀을 작게 둔다. 이어진 링크 블록은 옆으로 넘기는 한 줄에 놓는다.
class SchoolPageView extends StatelessWidget {
  const SchoolPageView({super.key, required this.blocks, this.credit});

  final List<SchoolBlock> blocks;
  final String? credit;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (i > 0) children.add(SizedBox(height: _gapBefore(block)));
      if (block.type != SchoolBlockType.link) {
        children.add(_Block(block: block));
        continue;
      }
      // 이어진 링크는 옆으로 넘기는 한 줄에.
      final links = [block];
      while (i + 1 < blocks.length &&
          blocks[i + 1].type == SchoolBlockType.link) {
        links.add(blocks[++i]);
      }
      children.add(_LinkRow(links: links));
    }
    final credit = this.credit;
    return ListView(
      children: [
        ...children,
        if (credit != null) ...[
          const SizedBox(height: AppSpacing.xxxl),
          _Credit(credit),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  /// 소제목 앞은 넓게 띄워 묶음이 나뉘어 보이게 한다.
  static double _gapBefore(SchoolBlock block) =>
      block.type == SchoolBlockType.heading ? AppSpacing.xxxl : AppSpacing.lg;
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
    SchoolBlockType.cards => _Cards(cards: block.cards),
    SchoolBlockType.link => _Link(block: block),
  };
}

/// 큰 배너: 남색 면 위에 작은 문구와 큰 문구를 가운데 둔다.
class _Hero extends StatelessWidget {
  const _Hero({required this.block});

  final SchoolBlock block;

  static const _height = 320.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return Container(
      height: _height,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Paragraphs(
              block.title,
              alignment: WrapAlignment.center,
              style: text.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            _Paragraphs(
              block.body,
              alignment: WrapAlignment.center,
              style: text.displaySmall?.copyWith(color: Colors.white),
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
        _Paragraphs(block.title, style: text.headlineMedium),
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
        // 한 줄의 카드는 높이를 맞춘다. 마지막 줄의 빈자리는 비워 둔다.
        return Column(
          children: [
            for (var start = 0; start < cards.length; start += columns) ...[
              if (start > 0) const SizedBox(height: AppSpacing.md),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var k = 0; k < columns; k++) ...[
                      if (k > 0) const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: start + k < cards.length
                            ? _CardTile(card: cards[start + k], text: text)
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.text});

  final SchoolCard card;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.emoji.isNotEmpty) ...[
            Text(card.emoji, style: text.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
          ],
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
    );
  }
}

/// 옆으로 넘기는 링크 카드 줄. 카드 폭은 같고, 오른쪽 끝 카드가 조금 잘려
/// 보여서 더 넘길 수 있다는 것을 알 수 있다.
class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.links});

  final List<SchoolBlock> links;

  static const _cardWidth = 440.0;

  @override
  Widget build(BuildContext context) {
    // QR 칸 높이가 같아서 카드 높이도 같다.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (j, link) in links.indexed) ...[
            if (j > 0) const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: _cardWidth,
              child: _Link(block: link),
            ),
          ],
        ],
      ),
    );
  }
}

/// 링크: 누르면 앱 안에서 화면 가득 열고, 휴대폰으로 볼 수 있게 QR 코드도 둔다.
class _Link extends StatelessWidget {
  const _Link({required this.block});

  final SchoolBlock block;

  static const _qrSize = 112.0;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: context.colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.schoolWeb(url: block.url, title: block.title),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              // QR은 흰 바탕이어야 휴대폰이 잘 읽는다.
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: QrImageView(
                  data: block.url,
                  size: _qrSize,
                  padding: EdgeInsets.zero,
                  semanticsLabel: '${block.title} QR 코드',
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(block.title, style: text.titleMedium),
                    if (block.body.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        block.body,
                        style: text.bodySmall?.copyWith(
                          color: semantic.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          '눌러서 보기',
                          style: text.labelSmall?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppSize.iconSm,
                          color: context.colors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 페이지 맨 아래: 선 하나와 만든 팀 한 줄.
class _Credit extends StatelessWidget {
  const _Credit(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: Text(
        text,
        style: context.textStyles.bodySmall?.copyWith(
          color: context.appColors.textSecondary,
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
  color: context.colors.surface,
  borderRadius: BorderRadius.circular(AppRadius.lg),
  border: Border.all(color: context.colors.outlineVariant),
);

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
