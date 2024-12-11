import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

import 'package:iot_baby_watch/core/utils/logger.dart';

import '../../../core/locators/locator.dart';

class MediaBody extends StatefulWidget {
  const MediaBody({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MediaBodyState createState() => _MediaBodyState();
}

class _MediaBodyState extends State<MediaBody> {
  late http.Response response;
  late http.Client client;
  late StreamController<Image> streamController;
  String URL_STREAM =
      'http://192.168.1.2:5123/video_streaming/${authRepository.getUser()!.code}';

  late InAppWebViewController webViewController;
  bool isLoading = false;

  WebSocket? socket;
  bool isSocketConnected = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refresh() async {
    logger.d('Refresh');
    webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(URL_STREAM))));
  }

  // Hàm để mở Dialog nhập URL mới
  Future<void> _showUrlDialog() async {
    TextEditingController urlController =
        TextEditingController(text: URL_STREAM);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Không đóng khi bấm bên ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter New URL'),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: 'Enter URL',
            ),
            keyboardType: TextInputType.url,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog khi bấm Cancel
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  URL_STREAM = urlController.text; // Cập nhật URL
                });
                Navigator.of(context).pop();
                _refresh(); // Reload lại WebView với URL mới
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            "Camera",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Optional: Add a background color
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              height: 300,
              width: double.infinity,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: WebUri.uri(Uri.parse(URL_STREAM))),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        print('Load Start: $url');
                      },
                      onLoadStop: (controller, url) {
                        print('Load Stop: $url');
                      },
                      onProgressChanged: (controller, progress) {
                        print('Progress: $progress');
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print('Console: ${consoleMessage.message}');
                      },
                      onLoadError: (controller, url, code, message) {
                        print('Error: $message');
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _showUrlDialog, // Gọi hàm mở Dialog khi bấm Reload
                  child: const Text('Tải lại'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
