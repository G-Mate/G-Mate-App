import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 홈 메뉴 하나.
class HomeMenuItem {
  const HomeMenuItem({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.badge,
    this.emphasized = false,
  });

  final GmIcons icon;
  final String title;
  final String description;

  /// null이면 아직 쓸 수 없는 메뉴.
  final VoidCallback? onTap;
  final String? badge;
  final bool emphasized;
}

/// 세로로 넘기는 메뉴 카드. 가운데 카드는 크고 밝게, 위아래 카드는 작고
/// 흐리게 보여 준다. 옆 카드를 누르면 가운데로 옮겨 오고, 가운데 카드를
/// 누르면 메뉴로 들어간다.
class MenuCarousel extends StatefulWidget {
  const MenuCarousel({super.key, required this.items});

  final List<HomeMenuItem> items;

  @override
  State<MenuCarousel> createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<MenuCarousel> {
  /// 화면 높이 대비 카드 한 장의 높이.
  static const _viewportFraction = 0.66;

  /// 가운데에서 한 칸 떨어진 카드의 크기와 진하기.
  static const _sideScale = 0.86;
  static const _sideOpacity = 0.4;

  /// 위아래에서 흐려지는 구간 (높이 대비).
  static const _edgeFade = 0.1;

  static const _dotSize = 8.0;
  static const _activeDotLength = 24.0;
  static const _move = Duration(milliseconds: 420);

  /// 끝없이 넘길 수 있도록 아주 큰 페이지 번호의 가운데에서 시작한다.
  static const _loopBase = 10000;

  late int _current = _loopBase * widget.items.length;
  late final _controller = PageController(
    viewportFraction: _viewportFraction,
    initialPage: _current,
  );

  int get _count => widget.items.length;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _page {
    if (_controller.hasClients && _controller.position.haveDimensions) {
      return _controller.page ?? _current.toDouble();
    }
    return _current.toDouble();
  }

  void _goTo(int index) => _controller.animateToPage(
    index,
    duration: _move,
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          // 위아래 끝에서 잘리는 카드는 흐려지며 사라지게 한다.
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0, _edgeFade, 1 - _edgeFade, 1],
            ).createShader(rect),
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              // itemCount가 없으면 끝없이 넘긴다. 메뉴는 차례대로 되풀이된다.
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, i) {
                final item = widget.items[i % _count];
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final d = (_page - i).abs().clamp(0.0, 1.0);
                    return Opacity(
                      opacity: 1 - (1 - _sideOpacity) * d,
                      child: Transform.scale(
                        scale: 1 - (1 - _sideScale) * d,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    // 주 메뉴의 빛 그림자가 잘리지 않을 만큼 위아래를 띄운다.
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.lg,
                    ),
                    child: GmMenuTile(
                      icon: item.icon,
                      title: item.title,
                      description: item.description,
                      badge: item.badge,
                      emphasized: item.emphasized,
                      // 가운데가 아닌 카드는 누르면 가운데로 옮겨 온다.
                      onTap: i == _current ? item.onTap : () => _goTo(i),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        // 몇 번째 메뉴인지 알려 주는 세로 점.
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _count; i++)
              GestureDetector(
                onTap: () => _goTo(_current - _current % _count + i),
                child: AnimatedContainer(
                  duration: AppDuration.slow,
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  width: _dotSize,
                  height: i == _current % _count ? _activeDotLength : _dotSize,
                  decoration: BoxDecoration(
                    color: i == _current % _count
                        ? colors.primary
                        : colors.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
