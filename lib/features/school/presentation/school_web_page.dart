import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/design_system.dart';

/// 학교 개요의 링크를 앱 안에서 화면 가득 연다.
///
/// 위에 얇은 줄만 두고 나머지는 웹 페이지다. 두 가지 뒤로 가기를 나눈다.
/// - 왼쪽 둥근 버튼: 웹을 닫고 학교 개요로 돌아간다 (앱 화면의 뒤로 가기).
/// - 오른쪽 [이전 페이지]: 웹 안에서 지나온 페이지로 돌아간다. 처음 페이지면
///   누를 수 없다.
///
/// Android 뒤로 가기는 웹 안에서 먼저 돌아가고, 처음 페이지면 학교 개요로 간다.
class SchoolWebPage extends StatefulWidget {
  const SchoolWebPage({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<SchoolWebPage> createState() => _SchoolWebPageState();
}

class _SchoolWebPageState extends State<SchoolWebPage> {
  static const _barHeight = 3.0;

  /// 위 줄 높이. 뒤로 가기 버튼(56)과 위아래 여백 12씩.
  static const _headerHeight = AppSize.touchTargetMin + AppSpacing.sm * 2;
  static const _loaded = 100;

  /// 학교 홈페이지처럼 PC 폭으로 고정된 페이지는 태블릿에서 오른쪽이 잘린다.
  /// 그림·글꼴을 늦게 불러오며 폭이 바뀌고 다 불러왔다는 알림이 안 올 때도
  /// 있어서, 페이지 안에 1초마다 폭을 화면에 맞추는 일을 걸어 둔다. 웹뷰 안의
  /// 창 폭은 페이지 폭을 따라 늘어날 수 있어서 화면 폭을 넘겨준다.
  static String _fitWidthScript(double viewWidth) =>
      'window.__gmViewWidth = $viewWidth;'
      'if (!window.__gmFit) {'
      '  window.__gmFit = function () {'
      '    if (!document.body) return;'
      "    document.body.style.zoom = '';"
      '    var width = document.documentElement.scrollWidth;'
      '    if (width > window.__gmViewWidth) {'
      '      document.body.style.zoom = window.__gmViewWidth / width;'
      '    }'
      '  };'
      '  setInterval(window.__gmFit, 1000);'
      '}'
      'window.__gmFit();';

  /// 학교 홈페이지는 들어오자마자 공지 팝업을 새 창(window.open)으로 띄운다.
  /// 웹뷰는 새 창 없이 지금 화면을 그 팝업으로 바꿔 버려서, 팝업 주소로
  /// 가는 것은 막는다.
  static final _popupPath = RegExp(r'/x?popup/', caseSensitive: false);

  WebViewController? _controller;
  double _viewWidth = 0;
  int _progress = 0;
  bool _failed = false;

  /// 웹 안에서 돌아갈 페이지가 있는지. [이전 페이지]를 켜고 끈다.
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    // 웹뷰 플랫폼이 없는 곳(위젯 테스트)에서는 주소만 보여 준다.
    if (WebViewPlatform.instance == null) return;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
            _fitWidth();
          },
          onPageFinished: (_) => _fitWidth(),
          onUrlChange: (_) => _refreshCanGoBack(),
          onNavigationRequest: (request) =>
              _popupPath.hasMatch(Uri.tryParse(request.url)?.path ?? '')
              ? NavigationDecision.prevent
              : NavigationDecision.navigate,
          onWebResourceError: (e) {
            // 그림 하나가 안 오는 것은 넘기고, 페이지 자체를 못 열 때만 알린다.
            if (mounted && (e.isForMainFrame ?? true)) {
              setState(() => _failed = true);
            }
          },
        ),
      );
    _openFirstPage();
  }

  void _openFirstPage() {
    setState(() {
      _failed = false;
      _progress = 0;
    });
    _controller?.loadRequest(Uri.parse(widget.url));
  }

  Future<void> _refreshCanGoBack() async {
    final can = await _controller?.canGoBack() ?? false;
    if (mounted && can != _canGoBack) setState(() => _canGoBack = can);
  }

  /// [이전 페이지]: 웹 안에서 한 페이지 돌아간다.
  Future<void> _webBack() async {
    await _controller?.goBack();
    await _refreshCanGoBack();
  }

  /// 웹을 닫고 학교 개요로 돌아간다.
  void _close() => context.pop();

  void _fitWidth() {
    if (_viewWidth <= 0) return;
    // 페이지가 바뀌는 중에는 실패할 수 있다. 다음 진행 때 다시 맞춘다.
    _controller?.runJavaScript(_fitWidthScript(_viewWidth)).ignore();
  }

  /// Android 뒤로 가기: 웹에서 지나온 페이지가 있으면 그리로, 없으면 닫는다.
  Future<void> _systemBack() async {
    final controller = _controller;
    if (controller != null && !_failed && await controller.canGoBack()) {
      await _webBack();
      return;
    }
    if (mounted) _close();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;
    final semantic = context.appColors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _systemBack();
      },
      child: GmBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 웹을 크게 보이도록 위 줄은 얇게 두고, 아래 선으로 웹과 나눈다.
                Container(
                  height: _headerHeight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: context.colors.outlineVariant),
                    ),
                  ),
                  child: Row(
                    children: [
                      GmBackButton(onPressed: _close),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: text.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              Uri.parse(widget.url).host,
                              maxLines: 1,
                              style: text.labelSmall?.copyWith(
                                color: semantic.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      GmButton(
                        label: '이전 페이지',
                        icon: Icons.undo_rounded,
                        size: GmButtonSize.small,
                        variant: GmButtonVariant.outline,
                        onPressed: _canGoBack && !_failed ? _webBack : null,
                      ),
                    ],
                  ),
                ),
                Expanded(child: _web(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _web(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return Center(
        child: Text(widget.url, style: context.textStyles.bodySmall),
      );
    }
    if (_failed) {
      return GmEmptyState(
        icon: Icons.wifi_off_rounded,
        title: '페이지를 열지 못했어요',
        message: '인터넷 연결을 확인해 주세요',
        action: GmButton(
          label: '다시 시도',
          icon: Icons.refresh_rounded,
          variant: GmButtonVariant.outline,
          onPressed: _openFirstPage,
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewWidth = constraints.maxWidth;
        return Stack(
          children: [
            WebViewWidget(controller: controller),
            if (_progress < _loaded)
              LinearProgressIndicator(
                value: _progress / _loaded,
                minHeight: _barHeight,
              ),
          ],
        );
      },
    );
  }
}
