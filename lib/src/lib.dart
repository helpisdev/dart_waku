import 'dart:ffi';

import 'package:path/path.dart';
import 'package:universal_io/io.dart';

import 'nwaku_bindings.dart';

const String _libName = 'waku';
final String _outDir = 'packages${separator}nwaku${separator}build$separator';
final DynamicLibrary _dylib = DynamicLibrary.open(_outDir + _binary);

String get _binary {
  if (Platform.isMacOS || Platform.isIOS) {
    return '$_libName.framework/$_libName';
  } else if (Platform.isAndroid || Platform.isLinux) {
    return 'lib$_libName.so';
  } else if (Platform.isWindows) {
    return '$_libName.dll';
  } else {
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }
}

final Waku waku = Waku(_dylib);
