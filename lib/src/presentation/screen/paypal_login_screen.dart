import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalLoginScreen extends StatefulWidget {
  const PaypalLoginScreen(
    this.url, {
    super.key,
    this.redirectURL,
    required this.appBar,
  });

  final String url;
  final String? redirectURL;
  final Widget appBar;

  @override
  State<PaypalLoginScreen> createState() => _PaypalLoginScreenState();
}

class _PaypalLoginScreenState extends State<PaypalLoginScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController();
    _controller.loadRequest(Uri.parse(widget.url));
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (navigationRequest) {
        if (widget.redirectURL != null &&
            navigationRequest.url.startsWith(widget.redirectURL!)) {
          Navigator.pop(context, navigationRequest.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            widget.appBar,
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
