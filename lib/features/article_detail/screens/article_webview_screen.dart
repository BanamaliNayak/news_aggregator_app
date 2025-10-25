import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebViewScreen extends StatefulWidget {
// region properties
  final String url;
  final String title;
// endregion

// region constructor
  const ArticleWebViewScreen(
      {super.key, required this.url, required this.title});
// endregion

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
// region properties
  late final WebViewController _controller;
  int _loadingPercentage = 0;
// endregion

// region lifecycle
  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // You can show a snackbar or error page here
            debugPrint('''
Page error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
// endregion

// region build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Add navigation controls
          NavigationControls(controller: _controller),
        ],
      ),
      body: Column(
        children: [
          if (_loadingPercentage < 100)
            LinearProgressIndicator(value: _loadingPercentage / 100.0),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
// endregion
}

// region helpers
class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.controller});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => controller.reload(),
        ),
      ],
    );
  }
}
// endregion