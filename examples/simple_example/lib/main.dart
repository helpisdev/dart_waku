// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:dart_waku/dart_waku.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

// nim c --out:build/libwaku.so --app:lib --opt:size --noMain --header
// -d:chronicles_log_level=ERROR --verbosity:0 --hints:off
// -d:chronicles_log_level=TRACE
// -d:git_version="v0.19.0-rc.0-2-gbf8fa8"
// -d:release library/libwaku.nim
class _MyHomePageState extends State<MyHomePage> {
  WakuNode? node;
  ServerStatus? _server;
  static const String _nodeKey =
      '377CA363CE7F99010F378BA8E02BB3D6D7033E00C4FACE2B1C3CB5008D64FEB8';

  void onError(final String msg, final int msgLen) {
    setState(() {
      _server = ServerStatus.notStarted;
    });
    if (kDebugMode) {
      print(msg);
    }
  }

  void create() {
    _server = ServerStatus.started;
    node = WakuNode(
      config: <String, dynamic>{
        'host': '127.0.0.1',
        'port': 60000,
        'key': _nodeKey,
        'relay': true,
      },
      onError: onError,
    );
    if (node?.status == ServerStatus.started) {
      unawaited(node?.start());
    }
  }

  @override
  void dispose() {
    unawaited(node?.stop());
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Has the server started: $_server.'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: create,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WakuNode>('node', node));
  }
}
