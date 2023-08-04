// ignore_for_file: public_member_api_docs

import 'dart:ffi';

import 'package:path/path.dart';
import 'package:universal_io/io.dart';

import 'nwaku_bindings.dart';

/// Name of the native Waku library.
const String _libwakuName = 'waku';

/// Output directory where the native library is located.
final String _wakuLibDir = _join('nwaku');

/// Loads the native Waku library dynamically.
final DynamicLibrary _wakuLib = _openDynamicLibrary(_wakuLibDir, _libwakuName);

/// Waku library bindings.
///
/// Initializes the native Waku library.
final Waku waku = Waku(_wakuLib);

typedef WakuMsgSize = int;
typedef CString = Pointer<Char>;

/// Callback for Waku events and handlers.
typedef DartWakuCallBack = void Function(String msg, WakuMsgSize msgSize);

DynamicLibrary _openDynamicLibrary(final String out, final String libname) {
  late final String path;
  if (Platform.isIOS) {
    path = '$libname.framework/$libname';
  } else if (Platform.isAndroid || Platform.isLinux || Platform.isFuchsia) {
    path = 'lib$libname.so';
  } else if (Platform.isMacOS) {
    path = 'lib$libname.dylib';
  } else if (Platform.isWindows) {
    path = '$libname.dll';
  } else {
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }

  return DynamicLibrary.open(out + path);
}

String _join(final String subfolder) =>
    'packages$separator$subfolder${separator}build$separator';
