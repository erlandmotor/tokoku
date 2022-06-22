// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teratesejahtera/widget/navigation_controls.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key, this.cookieManager}) : super(key: key);

  final CookieManager? cookieManager;

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  bool isLoading = true;

  final Completer<WebViewController> _completerController =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  WebViewController? _controller;

  // Future<bool> _exitApp(BuildContext context) async {
  //   if (await _controller.canGoBack()) {
  //     print("onwill goback");
  //     _controller.goBack();
  //     return Future.value(true);
  //   } else {
  //     Scaffold.of(context).showSnackBar(
  //       const SnackBar(content: Text("No back history item")),
  //     );
  //     return Future.value(false);
  //   }
  // }

  // Future<bool> _handleBack(context) async {
  //   print('masuk handle');
  //   var status = await _controller!.canGoBack();
  //   print(status);
  //   if (await _controller!.canGoBack()) {
  //     print('masuk bacck');
  //     _controller!.goBack();
  //     return false;
  //   }

  // return true;
  // var status = await _controller!.canGoBack();
  // if (status) {
  //   _controller!.goBack();
  //   return Future.value(false);
  // } else {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Do you want to exit'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             SystemNavigator.pop();
  //           },
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );
  //   return Future.value(true);
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terate Sejahtera'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_completerController.future),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: 'https://ppob.teratesejahtera.com/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                _completerController.complete(webViewController);
                await _controller?.runJavascript('document.cookie');
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              onProgress: (progress) {
                debugPrint('$progress %');
              },
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}
