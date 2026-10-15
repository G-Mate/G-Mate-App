import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/design_system.dart';

/// 학교 홈페이지를 앱 안에서 띄운다. 불러오는 동안 위에 얇은 막대를,
/// 못 불러오면 [다시 시도]를 보여 준다. [reloadCount]가 늘면 처음 주소로
/// 다시 연다.
class SchoolHomepageView extends StatefulWidget {
  const SchoolHomepageView({
    super.key,
    required this.url,
    this.reloadCount = 0,
  });

  final String url;
  final int reloadCount;

  @override
  State<SchoolHomepageView> createState() => _SchoolHomepageViewState();
}

class _SchoolHomepageViewState extends State<SchoolHomepageView> {
  static const _barHeight = 3.0;
  static const _loaded = 100;

  /// 학교 홈페이지는 PC 화면 폭(1400px)으로 만들어져 태블릿에서 오른쪽이
  /// 잘린다. 페이지 폭을 이 칸의 폭에 맞춰 줄인다.
  ///
  /// 홈페이지는 그림·글꼴을 늦게 불러오며 폭이 바뀌고, 다 불러왔다는 알림이
  /// 오지 않을 때도 있다. 그래서 페이지 안에 1초마다 폭을 다시 맞추는 일을
  /// 한 번 걸어 둔다. 웹뷰 안의 창 폭은 페이지 폭을 따라 늘어날 수 있어서
  /// 칸 폭을 넘겨준다.
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

  /// 이 칸의 논리 폭. 그릴 때 정한다.
  double _viewWidth = 0;

  WebViewController? _controller;
  int _progress = 0;
  bool _failed = false;

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
          onWebResourceError: (e) {
            // 그림 하나가 안 오는 것은 넘기고, 페이지 자체를 못 열 때만 알린다.
            if (mounted && (e.isForMainFrame ?? true)) {
              setState(() => _failed = true);
            }
          },
        ),
      );
    _open();
  }

  void _fitWidth() {
    if (_viewWidth <= 0) return;
    // 페이지가 바뀌는 중에는 실패할 수 있다. 다음 진행 때 다시 맞춘다.
    _controller?.runJavaScript(_fitWidthScript(_viewWidth)).ignore();
  }

  @override
  void didUpdateWidget(SchoolHomepageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url ||
        widget.reloadCount != oldWidget.reloadCount) {
      _open();
    }
  }

  void _open() {
    final uri = Uri.tryParse(widget.url);
    if (uri == null || !uri.hasScheme) {
      setState(() => _failed = true);
      return;
    }
    setState(() {
      _failed = false;
      _progress = 0;
    });
    _controller?.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return Center(
        child: Text(widget.url, style: context.textStyles.bodySmall),
      );
    }
    if (_failed) {
      return GmEmptyState(
        icon: Icons.wifi_off_rounded,
        title: '홈페이지를 열지 못했어요',
        message: '인터넷 연결이나 관리 모드의 주소를 확인해 주세요',
        action: GmButton(
          label: '다시 시도',
          icon: Icons.refresh_rounded,
          variant: GmButtonVariant.outline,
          onPressed: _open,
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
