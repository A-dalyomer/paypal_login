import 'dart:async';

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
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            widget.appBar,
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                navigationDelegate: (NavigationRequest request) {
                  if (widget.redirectURL != null &&
                      request.url.startsWith(widget.redirectURL!)) {
                    Navigator.pop(context, request.url);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
