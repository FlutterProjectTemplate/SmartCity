import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../constant_value/const_colors.dart';
import '../../../constant_value/const_fonts.dart';
import '../../../l10n/l10n_extention.dart';

class SimpleWebViewExample extends StatefulWidget {
  const SimpleWebViewExample({super.key});

  @override
  State<SimpleWebViewExample> createState() => _SimpleWebViewExampleState();
}

class _SimpleWebViewExampleState extends State<SimpleWebViewExample> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {
    _FontSizeAdjustment();
    }));
    _controller.enableZoom(true);
    _loadLocalHtml();
  }

  Future<void> _loadLocalHtml() async {
    final String htmlContent = await rootBundle.loadString('assets/rule.html');
    _controller.loadHtmlString(htmlContent);
  }

  void _FontSizeAdjustment() {
    _controller.runJavaScript("""
      document.body.style.fontSize = '35px';
    """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColors.tertiaryContainerColor,
        title: Text(
          L10nX.getStr.privacy_policy,
          style: ConstFonts()
              .copyWithTitle(fontSize: 25, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}