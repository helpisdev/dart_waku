/// The Dart Waku bindings library provides Dart APIs for interacting with Waku.
///
/// Waku is a private peer-to-peer messaging protocol focused on privacy and
/// censorship resistance. The Waku protocol allows nodes to anonymously publish
/// and receive messages via a gossip protocol.
///
/// This Dart package includes bindings to the underlying Waku library
/// implemented in Nim. It exposes a high-level Dart API for working with Waku
/// in Dart applications.
///
/// The key classes provided are:
/// - [WakuNode] - Main entry point for interacting with Waku. Used to configure
///   a Waku node, connect to the network, publish/subscribe to messages etc.
/// - [WakuRelay] - Class representing a Waku Relay Node.
/// - [WakuMessage] - Class representing a Waku message that can be published.
/// - [DartWakuCallBack] - Callback signature used by Waku methods.
/// - [ReturnCode] - Return codes indicating success or failure of Waku API
///   calls.
/// - [WakuException] - Exception type thrown on Waku errors.
/// - [ServerStatus] - Indicates if the created node is in a valid running
///   state.
///
/// The [WakuNode] class is the main access point for interacting with Waku. An
/// application will typically create an instance, configure it, and then use it
/// to connect to the Waku network and send/receive messages.
///
/// This library is intended to provide a simple Dart-native interface to
/// leverage the Waku protocol in Dart server and Flutter applications.
library waku;

import 'src/dart_waku_base.dart'
    show
        ReturnCode,
        ServerStatus,
        WakuException,
        WakuMessage,
        WakuNode,
        WakuRelay;
import 'src/lib.dart' show DartWakuCallBack;

export 'src/dart_waku_base.dart'
    show
        ReturnCode,
        ServerStatus,
        WakuException,
        WakuMessage,
        WakuNode,
        WakuRelay;
export 'src/lib.dart' show DartWakuCallBack, WakuMsgSize;
