import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class NewsView extends StatefulWidget {
  late String url;
  NewsView(this.url, {super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late String finalUrl;
  bool isLoading = true;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (((widget.url).toString()).contains("http://")) {
      finalUrl = ((widget.url).toString()).replaceAll("http://", "https://");
    } else {
      finalUrl = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "Akhbaar",
            style: TextStyle(
                fontFamily: "Erode",
                fontWeight: FontWeight.w500,
                decorationColor: Colors.black,
                decoration: TextDecoration.underline,
                fontSize: 50),
          ),
          centerTitle: true,
        ),
        body:
          Stack(
            children: [Container(
              margin: const EdgeInsets.all(5),
              child: WebView(
                navigationDelegate: (NavigationRequest request) {
                  return NavigationDecision.prevent;
                },
                initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
                  initialUrl: finalUrl,
                  javascriptMode: JavascriptMode.disabled,
                  // javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    setState(() {
                      isLoading = false;
                      controller.complete(webViewController);
                    });
                  }),
            ),
          if (isLoading)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),]
        ),);
  }
}
