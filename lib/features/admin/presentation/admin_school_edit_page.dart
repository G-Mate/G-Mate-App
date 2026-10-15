import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../school/domain/school_info.dart';
import '../../school/presentation/widgets/school_page_view.dart';
import 'bloc/admin_school_edit_cubit.dart';
import 'bloc/admin_school_edit_state.dart';
import 'widgets/admin_section.dart';

/// 관리 모드 - 학교 개요 편집. 노션처럼 블록을 쌓아 페이지를 만든다.
///
/// 왼쪽에서 블록을 넣고·고치고·끌어서 옮기며, 오른쪽에서 방문객이 볼
/// 페이지를 바로 미리 본다.
class AdminSchoolEditPage extends StatelessWidget {
  const AdminSchoolEditPage({super.key});

  @override
  Widget build(BuildContext context) =>
      GmDenseTheme(child: Builder(builder: _build));

  Widget _build(BuildContext context) {
    return BlocConsumer<AdminSchoolEditCubit, AdminSchoolEditState>(
      listenWhen: (prev, next) => !prev.isSaved && next.isSaved,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('학교 개요를 저장했어요')));
        context.pop();
      },
      builder: (context, state) {
        final info = state.info;
        if (state.isLoading || info == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final cubit = context.read<AdminSchoolEditCubit>();

        return GmScaffold(
          eyebrow: '관리 모드',
          title: '학교 개요',
          onBack: () => context.pop(),
          actions: [
            _AddBlockButton(onSelected: cubit.addBlock),
            GmButton(
              label: '취소',
              size: GmButtonSize.small,
              variant: GmButtonVariant.outline,
              onPressed: () => context.pop(),
            ),
            GmButton(
              label: '저장',
              icon: Icons.check_rounded,
              size: GmButtonSize.small,
              onPressed: cubit.save,
            ),
          ],
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: AdminSection(
                  title: '블록',
                  trailing: Text(
                    '손잡이를 끌어 순서를 바꿔요',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  child: _BlockList(state: state, cubit: cubit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 5,
                child: AdminSection(
                  title: '미리 보기',
                  child: _Preview(info: info),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 블록 편집 칸 목록. 블록을 새로 넣으면 맨 아래로 내려 보여 준다.
class _BlockList extends StatefulWidget {
  const _BlockList({required this.state, required this.cubit});

  final AdminSchoolEditState state;
  final AdminSchoolEditCubit cubit;

  @override
  State<_BlockList> createState() => _BlockListState();
}

class _BlockListState extends State<_BlockList> {
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(_BlockList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final added =
        widget.state.blockIds.length > oldWidget.state.blockIds.length;
    if (!added) return;
    // 새 블록이 그려진 뒤 끝으로 내린다 (만든 사람들 칸 바로 위).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: AppDuration.slow,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.state.info!;
    final cubit = widget.cubit;
    return ReorderableListView.builder(
      scrollController: _scroll,
      buildDefaultDragHandles: false,
      itemCount: info.blocks.length,
      onReorderItem: cubit.moveBlock,
      footer: _CreditsEditor(info: info, cubit: cubit),
      itemBuilder: (context, i) => _BlockEditor(
        key: ValueKey('block-${widget.state.blockIds[i]}'),
        index: i,
        block: info.blocks[i],
        cardRevision: widget.state.cardRevision,
        cubit: cubit,
      ),
    );
  }
}

/// [블록 추가]: 누르면 블록 종류를 고르는 목록이 열린다.
class _AddBlockButton extends StatelessWidget {
  const _AddBlockButton({required this.onSelected});

  final ValueChanged<SchoolBlockType> onSelected;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, _) => GmButton(
        label: '블록 추가',
        icon: Icons.add_rounded,
        size: GmButtonSize.small,
        variant: GmButtonVariant.secondary,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        for (final type in SchoolBlockType.values)
          MenuItemButton(
            leadingIcon: Icon(_blockIcon(type), size: AppSize.iconSm),
            onPressed: () => onSelected(type),
            child: Text(type.label),
          ),
      ],
    );
  }
}

IconData _blockIcon(SchoolBlockType type) => switch (type) {
  SchoolBlockType.hero => Icons.panorama_outlined,
  SchoolBlockType.heading => Icons.title_rounded,
  SchoolBlockType.text => Icons.notes_rounded,
  SchoolBlockType.image => Icons.image_outlined,
  SchoolBlockType.cards => Icons.grid_view_rounded,
  SchoolBlockType.link => Icons.qr_code_2_rounded,
};

/// 방문객 화면과 같은 페이지를 이 칸 폭에 맞게 줄여 보여 준다.
class _Preview extends StatelessWidget {
  const _Preview({required this.info});

  final SchoolInfo info;

  /// 방문객 화면에서 페이지가 차지하는 폭.
  static const _pageWidth = 1040.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / _pageWidth;
        return ClipRect(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: _pageWidth,
              height: constraints.maxHeight / scale,
              // 관리 모드의 촘촘한 테마 대신 방문객 화면 테마로 그린다.
              child: Theme(
                data: AppTheme.light(),
                child: SchoolPageView(info: info),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 블록 하나의 편집 칸: 머리줄(종류, 지우기, 손잡이)과 종류별 입력.
class _BlockEditor extends StatelessWidget {
  const _BlockEditor({
    super.key,
    required this.index,
    required this.block,
    required this.cardRevision,
    required this.cubit,
  });

  final int index;
  final SchoolBlock block;
  final int cardRevision;
  final AdminSchoolEditCubit cubit;

  static const _bodyLines = 3;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    void change(SchoolBlock b) => cubit.changeBlock(index, b);

    final fields = <Widget>[
      if (block.type == SchoolBlockType.hero ||
          block.type == SchoolBlockType.image)
        AdminPhotoField(
          image: switch (block.imagePath) {
            final path? => FileImage(File(path)),
            null => null,
          },
          placeholder: const GmPlaceArt(icon: GmIcons.school),
          hint: block.type == SchoolBlockType.hero
              ? '없으면 남색 면 위에 글자만 보여요'
              : '페이지 폭에 맞춰 크게 보여요',
          onPick: () => cubit.pickImage(index),
          onRemove: () => cubit.removeImage(index),
        ),
      if (block.type
          case SchoolBlockType.hero ||
              SchoolBlockType.heading ||
              SchoolBlockType.link)
        _Field(
          label: switch (block.type) {
            SchoolBlockType.hero => '작은 문구',
            SchoolBlockType.link => '이름',
            _ => '소제목',
          },
          value: block.title,
          onChanged: (v) => change(block.copyWith(title: v)),
        ),
      if (block.type
          case SchoolBlockType.hero ||
              SchoolBlockType.heading ||
              SchoolBlockType.text ||
              SchoolBlockType.image)
        _Field(
          label: switch (block.type) {
            SchoolBlockType.hero => '큰 문구',
            SchoolBlockType.text => '본문',
            _ => '설명',
          },
          value: block.body,
          lines: block.type == SchoolBlockType.text ? _bodyLines : 1,
          onChanged: (v) => change(block.copyWith(body: v)),
        ),
      if (block.type == SchoolBlockType.link)
        _Field(
          label: '주소',
          value: block.url,
          hint: 'https://로 시작하는 주소. 페이지에는 QR 코드로 보여요',
          keyboardType: TextInputType.url,
          onChanged: (v) => change(block.copyWith(url: v)),
        ),
      if (block.type == SchoolBlockType.cards) ...[
        for (var j = 0; j < block.cards.length; j++)
          _CardEditor(
            key: ValueKey('card-$cardRevision-$j'),
            card: block.cards[j],
            onChanged: (c) => cubit.changeCard(index, j, c),
            onRemove: () => cubit.removeCard(index, j),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => cubit.addCard(index),
            icon: const Icon(Icons.add_rounded, size: AppSize.iconSm),
            label: const Text('카드 추가'),
          ),
        ),
      ],
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _blockIcon(block.type),
                size: AppSize.iconSm,
                color: context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(block.type.label, style: text.labelSmall)),
              IconButton(
                tooltip: '이 블록 지우기',
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(AppSize.buttonSmall),
                ),
                onPressed: () => cubit.removeBlock(index),
                icon: Icon(
                  Icons.close_rounded,
                  size: AppSize.iconSm,
                  color: semantic.textDisabled,
                ),
              ),
              ReorderableDragStartListener(
                index: index,
                child: SizedBox.square(
                  dimension: AppSize.buttonSmall,
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    size: AppSize.iconSm,
                    color: semantic.textSecondary,
                    semanticLabel: '순서 바꾸기',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ...fields,
        ],
      ),
    );
  }
}

/// 라벨 + 입력 칸 한 개.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.lines = 1,
    this.keyboardType,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final int lines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return AdminField(
      label: label,
      hint: hint,
      child: TextFormField(
        initialValue: value,
        minLines: lines,
        maxLines: lines,
        keyboardType: keyboardType,
        style: context.textStyles.bodyMedium,
        onChanged: onChanged,
      ),
    );
  }
}

/// 카드 한 장: 이모지, 제목, [지우기] / 설명.
class _CardEditor extends StatelessWidget {
  const _CardEditor({
    super.key,
    required this.card,
    required this.onChanged,
    required this.onRemove,
  });

  final SchoolCard card;
  final ValueChanged<SchoolCard> onChanged;
  final VoidCallback onRemove;

  static const _emojiWidth = 72.0;

  @override
  Widget build(BuildContext context) {
    final style = context.textStyles.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: _emojiWidth,
                child: TextFormField(
                  initialValue: card.emoji,
                  textAlign: TextAlign.center,
                  style: style,
                  decoration: const InputDecoration(hintText: '🙂'),
                  onChanged: (v) => onChanged(card.copyWith(emoji: v)),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: TextFormField(
                  initialValue: card.title,
                  style: style,
                  decoration: const InputDecoration(hintText: '카드 제목'),
                  onChanged: (v) => onChanged(card.copyWith(title: v)),
                ),
              ),
              IconButton(
                tooltip: '이 카드 지우기',
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(AppSize.buttonSmall),
                ),
                onPressed: onRemove,
                icon: Icon(
                  Icons.close_rounded,
                  size: AppSize.iconSm,
                  color: context.appColors.textDisabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            initialValue: card.body,
            style: style,
            decoration: const InputDecoration(hintText: '카드 설명'),
            onChanged: (v) => onChanged(card.copyWith(body: v)),
          ),
        ],
      ),
    );
  }
}

/// 맨 아래: 페이지 끝에 보이는 만든 사람들 이름.
class _CreditsEditor extends StatelessWidget {
  const _CreditsEditor({required this.info, required this.cubit});

  final SchoolInfo info;
  final AdminSchoolEditCubit cubit;

  static const _namesHint = '여러 명이면 쉼표로 나눠 적어요. 비우면 보이지 않아요';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('만든 사람들 (페이지 맨 아래)', style: context.textStyles.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          _Field(
            label: '팀 이름',
            value: info.teamName,
            onChanged: cubit.changeTeamName,
          ),
          _Field(
            label: '개발자',
            value: info.developer,
            hint: _namesHint,
            onChanged: cubit.changeDeveloper,
          ),
          _Field(
            label: '기획자',
            value: info.planner,
            hint: _namesHint,
            onChanged: cubit.changePlanner,
          ),
        ],
      ),
    );
  }
}
