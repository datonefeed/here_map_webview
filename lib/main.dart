import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController _controller;
  final String hereApiKey = "qRR-l4jRTEcbw8sZCVRF_M3Uh_iXzKWTiqldJFMRHo8";

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                debugPrint('Bắt đầu tải trang WebView');
              },
              onPageFinished: (String url) {
                debugPrint('Hoàn tất tải trang WebView');
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('Lỗi tải tài nguyên: ${error.description}');
              },
            ),
          )
          ..loadRequest(
            Uri.dataFromString(
              '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <script src="https://js.api.here.com/v3/3.1/mapsjs-core.js"></script>
            <script src="https://js.api.here.com/v3/3.1/mapsjs-service.js"></script>
            <script src="https://js.api.here.com/v3/3.1/mapsjs-ui.js"></script>
            <script src="https://js.api.here.com/v3/3.1/mapsjs-mapevents.js"></script>
            <link rel="stylesheet" type="text/css" href="https://js.api.here.com/v3/3.1/mapsjs-ui.css" />

            <script>
              window.onload = function() {
                try {
                  var platform = new H.service.Platform({
                    apikey: "$hereApiKey"
                  });

                  var defaultLayers = platform.createDefaultLayers();

                  var map = new H.Map(
                    document.getElementById('mapContainer'),
                    defaultLayers.vector.normal.map,
                    {
                      zoom: 14,
                      center: { lat: 21.02139, lng: 105.8523 },
                      pixelRatio: window.devicePixelRatio || 1 // Tối ưu cho màn hình retina
                    }
                  );

                  var ui = H.ui.UI.createDefault(map, defaultLayers);
                  var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));

                  // Log để debug
                  console.log('HERE Maps khởi tạo thành công');
                } catch (e) {
                  console.error('Lỗi khởi tạo HERE Maps: ' + e.message);
                }
              };
            </script>
            <style>
              body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                overflow: hidden;
              }
              #mapContainer {
                width: 100%;
                height: 100%;
              }
            </style>
          </head>
          <body>
            <div id="mapContainer"></div>
          </body>
          </html>
          ''',
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("HERE Maps in WebView")),
        body: SafeArea(child: WebViewWidget(controller: _controller)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
