import 'dart:convert' as convert;
import 'dart:ffi' as dart_ffi;

import 'package:ffi/ffi.dart' as ffi;

import '../dart_waku.dart';
import 'lib.dart' as lib;
import 'nwaku_bindings.dart';

/// Extension on `Pointer<Char>` to convert to a Dart string.
extension _ToDartString on lib.CString {
  /// Converts the [dart_ffi.Pointer] to a Dart string.
  String toDartString() => cast<ffi.Utf8>().toDartString();
}

/// Extension to convert Dart objects to C string pointers.
extension _ToCString on Object {
  /// Converts the object to a null-terminated C string pointer.
  lib.CString toCStr() => toString().toNativeUtf8().cast<dart_ffi.Char>();
}

/// Waku message type. Represents a `JSON` object.
typedef WakuMessage = Map<String, dynamic>;

/// Return codes from Waku API calls.
enum ReturnCode {
  /// Success code.
  ok(0),

  /// General error code.
  err(1),

  /// Missing callback error.
  missingCallback(2);

  /// Constructor.
  const ReturnCode(this.code);

  /// The return code number.
  final int code;

  /// Gets a [ReturnCode] from integer code.
  static ReturnCode fromCode(final int code) => ReturnCode.values.firstWhere(
        (final ReturnCode e) => e.code == code,
        orElse: () => throw UnsupportedError(
          'This error code is not currently supported.',
        ),
      );
}

enum ServerStatus {
  started,
  notStarted,
  stopped,
}

/// Waku node class providing access to Waku APIs.
class WakuNode {
  /// Creates a new [WakuNode] instance.
  WakuNode({
    required final WakuMessage config,
    required final lib.DartWakuCallBack onError,
  }) {
    _WakuCallbacks.cbs[_wakuNewOnErrorHandle] = onError;
    final ReturnCode res = ReturnCode.fromCode(
      lib.waku.waku_new(
        convert.jsonEncode(config).toCStr(),
        _WakuCallbacks.wakuNewOnError,
      ),
    );

    switch (res) {
      case ReturnCode.ok:
        status = ServerStatus.started;
      case ReturnCode.err:
      case ReturnCode.missingCallback:
        status = ServerStatus.notStarted;
    }
  }

  /// Waku relay API wrapper.
  static const WakuRelay _relay = WakuRelay._();

  /// Getter for relay API.
  WakuRelay get relay {
    _checkServerStatus();
    return _relay;
  }

  /// Whether the server is in a valid state to be used or not.
  ServerStatus status = ServerStatus.notStarted;

  /// Setter for relay callback.
  void setEventCallback(final lib.DartWakuCallBack cb) {
    _checkServerStatus();
    _WakuCallbacks.cbs[_setEventCallbackEventHandlerHandle] = cb;
    lib.waku.waku_set_event_callback(_WakuCallbacks.setEventCallback);
  }

  /// Start the Waku node.
  Future<void> start() async {
    _checkServerStatus();
    lib.waku.waku_start();
    status = ServerStatus.started;
  }

  /// Stop the Waku node.
  Future<void> stop() async {
    _checkServerStatus();
    lib.waku.waku_stop();
    status = ServerStatus.stopped;
  }

  /// Get the Waku version.
  void version(final lib.DartWakuCallBack onOk) {
    _checkServerStatus();
    _WakuCallbacks.cbs[_versionOnOkHandle] = onOk;
    lib.waku.waku_version(_WakuCallbacks.versionOnOk);
  }

  /// Connect to a peer.
  ReturnCode connect({
    required final String peerMultiAddr,
    required final int timeoutMs,
    required final lib.DartWakuCallBack onError,
  }) {
    _checkServerStatus();
    _WakuCallbacks.cbs[_connectOnErrorHandle] = onError;
    return ReturnCode.fromCode(
      lib.waku.waku_connect(
        peerMultiAddr.toCStr(),
        timeoutMs.abs(),
        _WakuCallbacks.connectOnError,
      ),
    );
  }

  /// Set pubsub topic.
  ReturnCode setPubsubTopic({
    required final String topicName,
    required final lib.DartWakuCallBack onOk,
  }) {
    _checkServerStatus();
    _WakuCallbacks.cbs[_setPubsubTopicOnOkHandle] = onOk;
    return ReturnCode.fromCode(
      lib.waku.waku_pubsub_topic(
        topicName.toCStr(),
        _WakuCallbacks.setPubsubTopicOnOk,
      ),
    );
  }

  /// Use default pubsub topic.
  ReturnCode useDefaultPubsubTopic({
    required final lib.DartWakuCallBack onOk,
  }) {
    _checkServerStatus();
    _WakuCallbacks.cbs[_useDefaultPubsubTopicOnOkHandle] = onOk;
    return ReturnCode.fromCode(
      lib.waku.waku_default_pubsub_topic(
        _WakuCallbacks.useDefaultPubsubTopicOnOk,
      ),
    );
  }

  /// Set content topic.
  ReturnCode setContentTopic({
    required final String appName,
    required final int appVersion,
    required final String contentTopic,
    required final String encoding,
    required final lib.DartWakuCallBack onOk,
  }) {
    _checkServerStatus();
    _WakuCallbacks.cbs[_setContentTopicOnOkHandle] = onOk;
    return ReturnCode.fromCode(
      lib.waku.waku_content_topic(
        appName.toCStr(),
        appVersion,
        contentTopic.toCStr(),
        encoding.toCStr(),
        _WakuCallbacks.setContentTopicOnOk,
      ),
    );
  }

  void _checkServerStatus() {
    if (status == ServerStatus.notStarted) {
      throw const WakuException(msg: 'Server has not been properly started.');
    }
  }
}

/// Provides access to Waku pubsub relay API.
class WakuRelay {
  const WakuRelay._();

  /// Subscribe to a pubsub topic.
  ReturnCode subscribe({
    required final String pubSubTopic,
    required final lib.DartWakuCallBack onError,
  }) {
    _WakuCallbacks.cbs[_subscribeOnErrorHandle] = onError;
    return ReturnCode.fromCode(
      lib.waku.waku_relay_subscribe(
        pubSubTopic.toCStr(),
        _WakuCallbacks.subscribeOnError,
      ),
    );
  }

  /// Unsubscribe from a pubsub topic.
  ReturnCode unsubscribe({
    required final String pubSubTopic,
    required final lib.DartWakuCallBack onError,
  }) {
    _WakuCallbacks.cbs[_unsubscribeOnErrorHandle] = onError;
    return ReturnCode.fromCode(
      lib.waku.waku_relay_unsubscribe(
        pubSubTopic.toCStr(),
        _WakuCallbacks.unsubscribeOnError,
      ),
    );
  }

  /// Publish message to a pubsub topic.
  ReturnCode publish({
    required final String pubSubTopic,
    required final WakuMessage message,
    required final int timeoutMs,
    required final lib.DartWakuCallBack onOk,
    required final lib.DartWakuCallBack onError,
  }) {
    _WakuCallbacks.cbs[_publishOnErrorHandle] = onError;
    _WakuCallbacks.cbs[_publishOnOkHandle] = onOk;
    return ReturnCode.fromCode(
      lib.waku.waku_relay_publish(
        pubSubTopic.toCStr(),
        convert.jsonEncode(message).toCStr(),
        timeoutMs,
        _WakuCallbacks.publishOnOk,
        _WakuCallbacks.publishOnError,
      ),
    );
  }
}

/// Exception thrown by Waku APIs.
class WakuException implements Exception {
  /// Constructor.
  const WakuException({required this.msg});

  /// Error message.
  final String msg;

  /// Returns error message.
  @override
  String toString() => 'WakuException: $msg';
}

class _WakuCallbacks {
  const _WakuCallbacks();

  static final WakuCallBack wakuNewOnError = dart_ffi.Pointer.fromFunction(
    _wakuNewOnError,
  );
  static final WakuCallBack setEventCallback = dart_ffi.Pointer.fromFunction(
    _setEventCallback,
  );
  static final WakuCallBack versionOnOk = dart_ffi.Pointer.fromFunction(
    _versionOnOk,
  );
  static final WakuCallBack connectOnError = dart_ffi.Pointer.fromFunction(
    _connectOnError,
  );
  static final WakuCallBack setPubsubTopicOnOk = dart_ffi.Pointer.fromFunction(
    _setPubsubTopicOnOk,
  );
  static final WakuCallBack useDefaultPubsubTopicOnOk =
      dart_ffi.Pointer.fromFunction(
    _useDefaultPubsubTopicOnOk,
  );
  static final WakuCallBack setContentTopicOnOk = dart_ffi.Pointer.fromFunction(
    _setContentTopicOnOk,
  );
  static final WakuCallBack subscribeOnError = dart_ffi.Pointer.fromFunction(
    _subscribeOnError,
  );
  static final WakuCallBack unsubscribeOnError = dart_ffi.Pointer.fromFunction(
    _unsubscribeOnError,
  );
  static final WakuCallBack publishOnOk = dart_ffi.Pointer.fromFunction(
    _publishOnOk,
  );
  static final WakuCallBack publishOnError = dart_ffi.Pointer.fromFunction(
    _publishOnError,
  );

  static final _CallbackRegistry cbs = <_CallbackHandle, lib.DartWakuCallBack?>{
    _wakuNewOnErrorHandle: null,
    _connectOnErrorHandle: null,
    _subscribeOnErrorHandle: null,
    _unsubscribeOnErrorHandle: null,
    _publishOnErrorHandle: null,
    _publishOnOkHandle: null,
    _versionOnOkHandle: null,
    _setPubsubTopicOnOkHandle: null,
    _useDefaultPubsubTopicOnOkHandle: null,
    _setContentTopicOnOkHandle: null,
    _setEventCallbackEventHandlerHandle: null,
  };

  static void _versionOnOk(final lib.CString msg, final WakuMsgSize msgSize) {
    cbs[_versionOnOkHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _setPubsubTopicOnOk(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_setPubsubTopicOnOkHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _useDefaultPubsubTopicOnOk(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_useDefaultPubsubTopicOnOkHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _setContentTopicOnOk(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_setContentTopicOnOkHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _publishOnOk(final lib.CString msg, final WakuMsgSize msgSize) {
    cbs[_publishOnOkHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _publishOnError(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_publishOnErrorHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _wakuNewOnError(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_wakuNewOnErrorHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _connectOnError(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_connectOnErrorHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _subscribeOnError(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_subscribeOnErrorHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _unsubscribeOnError(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[_unsubscribeOnErrorHandle]?.call(msg.toDartString(), msgSize);
  }

  static void _setEventCallback(
    final lib.CString msg,
    final WakuMsgSize msgSize,
  ) {
    cbs[const _CallbackHandle(
      _CallbackID.setEventCallback,
      _CallbackType.eventHandler,
    )]
        ?.call(msg.toDartString(), msgSize);
  }
}

typedef _CallbackRegistry = Map<_CallbackHandle, lib.DartWakuCallBack?>;

class _CallbackHandle {
  const _CallbackHandle(this.id, this.type);

  final _CallbackID id;
  final _CallbackType type;
}

enum _CallbackID {
  publish,
  subscribe,
  unsubscribe,
  version,
  setPubsubTopic,
  useDefaultPubsubTopic,
  setContentTopic,
  wakuNew,
  setEventCallback,
  connect,
}

enum _CallbackType {
  onOk,
  onError,
  eventHandler,
}

const _CallbackHandle _wakuNewOnErrorHandle = _CallbackHandle(
  _CallbackID.wakuNew,
  _CallbackType.onError,
);
const _CallbackHandle _connectOnErrorHandle = _CallbackHandle(
  _CallbackID.connect,
  _CallbackType.onError,
);
const _CallbackHandle _subscribeOnErrorHandle = _CallbackHandle(
  _CallbackID.subscribe,
  _CallbackType.onError,
);
const _CallbackHandle _unsubscribeOnErrorHandle = _CallbackHandle(
  _CallbackID.unsubscribe,
  _CallbackType.onError,
);
const _CallbackHandle _publishOnErrorHandle = _CallbackHandle(
  _CallbackID.publish,
  _CallbackType.onError,
);
const _CallbackHandle _publishOnOkHandle = _CallbackHandle(
  _CallbackID.publish,
  _CallbackType.onOk,
);
const _CallbackHandle _versionOnOkHandle = _CallbackHandle(
  _CallbackID.version,
  _CallbackType.onOk,
);
const _CallbackHandle _setPubsubTopicOnOkHandle = _CallbackHandle(
  _CallbackID.setPubsubTopic,
  _CallbackType.onOk,
);
const _CallbackHandle _useDefaultPubsubTopicOnOkHandle = _CallbackHandle(
  _CallbackID.useDefaultPubsubTopic,
  _CallbackType.onOk,
);
const _CallbackHandle _setContentTopicOnOkHandle = _CallbackHandle(
  _CallbackID.setContentTopic,
  _CallbackType.onOk,
);
const _CallbackHandle _setEventCallbackEventHandlerHandle = _CallbackHandle(
  _CallbackID.setEventCallback,
  _CallbackType.eventHandler,
);
