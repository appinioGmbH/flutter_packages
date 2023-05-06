import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileUtils {
  /// Returns true if success false otherwise
  /// Throws a [FileSystemException] if the operation fails.
  static Future<bool> writeBytesToFile({
    File? file,
    List<int>? bytes,
  }) async {
    if (file == null || (bytes?.isEmpty ?? true)) return false;
    if (!file.existsSync()) file.createSync(recursive: true, exclusive: false);
    file.writeAsBytesSync(bytes!);
    return true;
  }

  static Future<Directory> getTempDirectory() async => Directory(
      '${((Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory()) ?? await getTemporaryDirectory()).path}${Platform.pathSeparator}temp');

  static Future<String?> exposeFileFromAsset(
      {required String assetKey, bool overwrite = false}) async {
    try {
      Directory dir = await getTempDirectory();
      final File file = File('${dir.path}${Platform.pathSeparator}$assetKey');
      try {
        if (overwrite) {
          file.deleteSync(recursive: true);
        } else if (file.existsSync()) {
          return file.path;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      List<int> bytes =
          (await rootBundle.load('assets/$assetKey')).buffer.asUint8List();
      if (bytes.isEmpty) return null;
      await writeBytesToFile(file: file, bytes: bytes);
      return file.path;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
