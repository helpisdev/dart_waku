// ignore_for_file: public_member_api_docs

import 'dart:convert' as convert;
import 'dart:ffi' as dart_ffi;

import 'package:ffi/ffi.dart' as ffi;

import 'lib.dart' as lib;
import 'nwaku_bindings.dart' as bindings;

extension _ToDartString on dart_ffi.Pointer<dart_ffi.Char> {
  String toDartString() => cast<ffi.Utf8>().toDartString();
}

extension _ToCString on Object {
  dart_ffi.Pointer<dart_ffi.Char> toCStr() =>
      toString().toNativeUtf8().cast<dart_ffi.Char>();
}

extension _ToWakuCallback on WakuCallBack {
  bindings.WakuCallBack toWakuCallback() {
    void callback(
      final dart_ffi.Pointer<dart_ffi.Char> msg,
      final int len_0,
    ) =>
        this(msg.toDartString(), len_0);

    return dart_ffi.Pointer.fromFunction<
        dart_ffi.Void Function(
          dart_ffi.Pointer<dart_ffi.Char>,
          dart_ffi.Size,
        )>(callback);
  }
}

typedef WakuMessage = Map<String, dynamic>;
typedef WakuCallBack = void Function(String message, int len0);

enum ReturnCode {
  ok(0),
  err(1),
  missingCallback(2);

  const ReturnCode(this.code);

  final int code;

  static ReturnCode fromCode(final int code) => ReturnCode.values.firstWhere(
        (final ReturnCode e) => e.code == code,
        orElse: () => throw UnsupportedError(
          'This error code is not currently supported.',
        ),
      );
}

class WakuNode {
  factory WakuNode({
    required final WakuMessage json,
    required final WakuCallBack onError,
  }) {
    if (!_init) {
      lib.waku.waku_init_lib();
      _init = true;
    }

    return WakuNode._(config: json, onError: onError);
  }

  WakuNode._({
    required final WakuMessage config,
    required final WakuCallBack onError,
  }) {
    final ReturnCode res = ReturnCode.fromCode(
      lib.waku.waku_new(
        convert.jsonEncode(config).toCStr(),
        onError.toWakuCallback(),
      ),
    );

    switch (res) {
      case ReturnCode.ok:
        break;
      case ReturnCode.err:
        throw const WakuException(
          msg: 'Error initializing Waku Node!',
        );
      case ReturnCode.missingCallback:
        throw const WakuException(
          msg: 'Invalid error callback provided.',
        );
    }
  }

  static bool _init = false;

  final WakuRelay _relay = WakuRelay._();

  WakuRelay get relay => _relay;

  void start() => lib.waku.waku_start();
  void stop() => lib.waku.waku_stop();
  void poll() => lib.waku.waku_poll();
  void version(final WakuCallBack onOk) => lib.waku.waku_version(
        onOk.toWakuCallback(),
      );

  ReturnCode connect({
    required final String peerMultiAddr,
    required final int timeoutMs,
    required final WakuCallBack onError,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_connect(
          peerMultiAddr.toCStr(),
          timeoutMs.abs(),
          onError.toWakuCallback(),
        ),
      );

  ReturnCode setPubsubTopic({
    required final String topicName,
    required final WakuCallBack onOk,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_pubsub_topic(
          topicName.toCStr(),
          onOk.toWakuCallback(),
        ),
      );

  ReturnCode useDefaultPubsubTopic({
    required final WakuCallBack onOk,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_default_pubsub_topic(
          onOk.toWakuCallback(),
        ),
      );

  ReturnCode setContentTopic({
    required final String appName,
    required final int appVersion,
    required final String contentTopic,
    required final String encoding,
    required final WakuCallBack onOk,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_content_topic(
          appName.toCStr(),
          appVersion,
          contentTopic.toCStr(),
          encoding.toCStr(),
          onOk.toWakuCallback(),
        ),
      );
}

class WakuRelay {
  WakuRelay._();

  WakuCallBack? _callback;

  WakuCallBack? get callback => _callback;
  void setCallback(final WakuCallBack cb) {
    _callback = cb;
    lib.waku.waku_set_relay_callback(cb.toWakuCallback());
  }

  ReturnCode subscribe({
    required final String pubSubTopic,
    required final WakuCallBack onError,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_relay_subscribe(
          pubSubTopic.toCStr(),
          onError.toWakuCallback(),
        ),
      );

  ReturnCode unsubscribe({
    required final String pubSubTopic,
    required final WakuCallBack onError,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_relay_unsubscribe(
          pubSubTopic.toCStr(),
          onError.toWakuCallback(),
        ),
      );

  ReturnCode publish({
    required final String pubSubTopic,
    required final WakuMessage message,
    required final int timeoutMs,
    required final WakuCallBack onOk,
    required final WakuCallBack onError,
  }) =>
      ReturnCode.fromCode(
        lib.waku.waku_relay_publish(
          pubSubTopic.toCStr(),
          convert.jsonEncode(message).toCStr(),
          timeoutMs,
          onOk.toWakuCallback(),
          onError.toWakuCallback(),
        ),
      );
}

class WakuException implements Exception {
  const WakuException({required this.msg});

  final String msg;

  @override
  String toString() => 'WakuException: $msg';
}
