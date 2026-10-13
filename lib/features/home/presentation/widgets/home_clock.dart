import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

/// 남색 패널 오른쪽 아래의 시계와 날짜. 누르면 화면 전체로 커진다
/// ([HomeClockFocus]).
class HomeClock extends StatelessWidget {
  const HomeClock({super.key});

  static const heroTag = 'home-clock';

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => HomeClockFocus.open(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: heroTag,
            child: _Ticking(
              builder: (now) => Text(
                _hhmm(now),
                style: text.displaySmall?.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          _Ticking(
            builder: (now) => Text(
              _date(now),
              style: text.bodySmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 화면 전체에 크게 띄운 시계. 뒤쪽 화면은 흐리게 가리고, 초와 오전·오후,
/// 날짜를 함께 보여 준다. 화면을 누르거나 [_autoClose]가 지나면 닫힌다.
class HomeClockFocus extends StatefulWidget {
  const HomeClockFocus({super.key, required this.animation});

  final Animation<double> animation;

  static const _transition = Duration(milliseconds: 450);

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: _transition,
      reverseTransitionDuration: _transition,
      pageBuilder: (context, animation, _) =>
          HomeClockFocus(animation: animation),
    ),
  );

  @override
  State<HomeClockFocus> createState() => _HomeClockFocusState();
}

class _HomeClockFocusState extends State<HomeClockFocus> {
  /// 키오스크가 시계 화면에 머물러 있지 않도록 저절로 닫는 시간.
  static const _autoClose = Duration(seconds: 30);
  static const _blurSigma = 24.0;
  static const _scrimAlpha = 0.55;
  static const _clockWidth = 760.0;

  late final Timer _closeTimer = Timer(_autoClose, _close);

  @override
  void initState() {
    super.initState();
    _closeTimer;
  }

  @override
  void dispose() {
    _closeTimer.cancel();
    super.dispose();
  }

  void _close() {
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;
    final colors = context.colors;
    final fade = CurvedAnimation(
      parent: widget.animation,
      curve: Curves.easeOut,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _close,
      child: AnimatedBuilder(
        animation: fade,
        builder: (context, child) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _blurSigma * fade.value,
            sigmaY: _blurSigma * fade.value,
          ),
          child: ColoredBox(
            color: AppColors.navy.withValues(alpha: _scrimAlpha * fade.value),
            child: child,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: fade,
                child: _Ticking(
                  builder: (now) => Text(
                    now.hour < 12 ? '오전' : '오후',
                    style: text.titleMedium?.copyWith(
                      color: semantic.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _clockWidth,
                child: FittedBox(
                  child: Hero(
                    tag: HomeClock.heroTag,
                    child: _Ticking(
                      builder: (now) => Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: _hhmm(now)),
                            // 초는 작고 옅게 붙인다.
                            TextSpan(
                              text: ' ${_two(now.second)}',
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        style: text.displayLarge?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w500,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FadeTransition(
                opacity: fade,
                child: Column(
                  children: [
                    _Ticking(
                      builder: (now) => Text(
                        '${now.year}년 ${_date(now)}',
                        style: text.headlineSmall?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      '화면을 누르면 돌아가요',
                      style: text.bodySmall?.copyWith(
                        color: semantic.textSecondary,
                      ),
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

/// 1초마다 지금 시각으로 다시 그린다.
class _Ticking extends StatefulWidget {
  const _Ticking({required this.builder});

  final Widget Function(DateTime now) builder;

  @override
  State<_Ticking> createState() => _TickingState();
}

class _TickingState extends State<_Ticking> {
  static const _tick = Duration(seconds: 1);

  late DateTime _now = DateTime.now();
  late final Timer _timer = Timer.periodic(
    _tick,
    (_) => setState(() => _now = DateTime.now()),
  );

  @override
  void initState() {
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_now);
}

const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

String _two(int n) => n.toString().padLeft(2, '0');

String _hhmm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

String _date(DateTime t) =>
    '${t.month}월 ${t.day}일 ${_weekdays[t.weekday - 1]}요일';
