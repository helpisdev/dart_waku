// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings for `packages/nwaku/library/libwaku.h`.
///
/// Regenerate bindings with `dart run ffigen --config ffigen_waku.yaml`.
///
class Waku {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  Waku(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  Waku.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int waku_connect(
    ffi.Pointer<ffi.Char> peerMultiAddr,
    int timeoutMs,
    WakuCallBack onErrCb,
  ) {
    return _waku_connect(
      peerMultiAddr,
      timeoutMs,
      onErrCb,
    );
  }

  late final _waku_connectPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Char>, ffi.UnsignedInt,
              WakuCallBack)>>('waku_connect');
  late final _waku_connect = _waku_connectPtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, int, WakuCallBack)>();

  int waku_content_topic(
    ffi.Pointer<ffi.Char> appName,
    int appVersion,
    ffi.Pointer<ffi.Char> contentTopicName,
    ffi.Pointer<ffi.Char> encoding,
    WakuCallBack onOkCb,
  ) {
    return _waku_content_topic(
      appName,
      appVersion,
      contentTopicName,
      encoding,
      onOkCb,
    );
  }

  late final _waku_content_topicPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>,
              ffi.UnsignedInt,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              WakuCallBack)>>('waku_content_topic');
  late final _waku_content_topic = _waku_content_topicPtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, int, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, WakuCallBack)>();

  int waku_default_pubsub_topic(
    WakuCallBack onOkCb,
  ) {
    return _waku_default_pubsub_topic(
      onOkCb,
    );
  }

  late final _waku_default_pubsub_topicPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(WakuCallBack)>>(
          'waku_default_pubsub_topic');
  late final _waku_default_pubsub_topic =
      _waku_default_pubsub_topicPtr.asFunction<int Function(WakuCallBack)>();

  /// Creates a new instance of the waku node.
  /// Sets up the waku node from the given configuration.
  int waku_new(
    ffi.Pointer<ffi.Char> configJson,
    WakuCallBack onErrCb,
  ) {
    return _waku_new(
      configJson,
      onErrCb,
    );
  }

  late final _waku_newPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Char>, WakuCallBack)>>('waku_new');
  late final _waku_new = _waku_newPtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, WakuCallBack)>();

  int waku_pubsub_topic(
    ffi.Pointer<ffi.Char> topicName,
    WakuCallBack onOkCb,
  ) {
    return _waku_pubsub_topic(
      topicName,
      onOkCb,
    );
  }

  late final _waku_pubsub_topicPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>, WakuCallBack)>>('waku_pubsub_topic');
  late final _waku_pubsub_topic = _waku_pubsub_topicPtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, WakuCallBack)>();

  int waku_relay_publish(
    ffi.Pointer<ffi.Char> pubSubTopic,
    ffi.Pointer<ffi.Char> jsonWakuMessage,
    int timeoutMs,
    WakuCallBack onOkCb,
    WakuCallBack onErrCb,
  ) {
    return _waku_relay_publish(
      pubSubTopic,
      jsonWakuMessage,
      timeoutMs,
      onOkCb,
      onErrCb,
    );
  }

  late final _waku_relay_publishPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.UnsignedInt,
              WakuCallBack,
              WakuCallBack)>>('waku_relay_publish');
  late final _waku_relay_publish = _waku_relay_publishPtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int,
          WakuCallBack, WakuCallBack)>();

  int waku_relay_subscribe(
    ffi.Pointer<ffi.Char> pubSubTopic,
    WakuCallBack onErrCb,
  ) {
    return _waku_relay_subscribe(
      pubSubTopic,
      onErrCb,
    );
  }

  late final _waku_relay_subscribePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>, WakuCallBack)>>('waku_relay_subscribe');
  late final _waku_relay_subscribe = _waku_relay_subscribePtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, WakuCallBack)>();

  int waku_relay_unsubscribe(
    ffi.Pointer<ffi.Char> pubSubTopic,
    WakuCallBack onErrCb,
  ) {
    return _waku_relay_unsubscribe(
      pubSubTopic,
      onErrCb,
    );
  }

  late final _waku_relay_unsubscribePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>, WakuCallBack)>>('waku_relay_unsubscribe');
  late final _waku_relay_unsubscribe = _waku_relay_unsubscribePtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, WakuCallBack)>();

  void waku_set_event_callback(
    WakuCallBack callback,
  ) {
    return _waku_set_event_callback(
      callback,
    );
  }

  late final _waku_set_event_callbackPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WakuCallBack)>>(
          'waku_set_event_callback');
  late final _waku_set_event_callback =
      _waku_set_event_callbackPtr.asFunction<void Function(WakuCallBack)>();

  void waku_start() {
    return _waku_start();
  }

  late final _waku_startPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('waku_start');
  late final _waku_start = _waku_startPtr.asFunction<void Function()>();

  void waku_stop() {
    return _waku_stop();
  }

  late final _waku_stopPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('waku_stop');
  late final _waku_stop = _waku_stopPtr.asFunction<void Function()>();

  int waku_version(
    WakuCallBack onOkCb,
  ) {
    return _waku_version(
      onOkCb,
    );
  }

  late final _waku_versionPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(WakuCallBack)>>(
          'waku_version');
  late final _waku_version =
      _waku_versionPtr.asFunction<int Function(WakuCallBack)>();
}

const int RET_ERR = 1;

const int RET_MISSING_CALLBACK = 2;

const int RET_OK = 0;

typedef WakuCallBack = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Void Function(ffi.Pointer<ffi.Char> msg, ffi.Size len_0)>>;
