import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'paths_provider.dart';
import 'user_info_provider.dart';

final tempStorageProvider = NotifierProvider<TempStorageUtils, Map<String, String>>(() => TempStorageUtils());

class TempStorageUtils extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    return {};
  }

  Stream<Map<String, dynamic>> saveDataToLocalStorage(Uint8List data) {
    final StreamController<Map<String, dynamic>> controller = StreamController();
    final File? saveFile = _generateTempFile();

    if (saveFile != null) {
      saveFile.writeAsBytes(data).then((_) {
        controller.add({'success': true, 'message': 'Data saved successfully', 'file': saveFile});
        controller.close();
      }).catchError((error) {
        controller.add({'success': false, 'message': 'Failed to save data: $error', 'file': saveFile});
        controller.close();
      });
    } else {
      controller.add({'success': false, 'message': 'Temp directory not found'});
      controller.close();
    }

    return controller.stream;
  }

  Stream<Map<String, dynamic>> getDataFromTempFile(String filePath) {
    final StreamController<Map<String, dynamic>> controller = StreamController();

    final File tempFile = File(filePath);

    tempFile.length().then((fileLength) {
      const chunkSize = 512; // chunk size
      final totalChunks = (fileLength / chunkSize).ceil();
      var chunksRead = 0;

      final stream = tempFile.openRead();

      stream.listen(
        (chunk) {
          controller.add({
            "status": "reading",
            "message": "reading file data",
            "progress": '${++chunksRead}/$totalChunks',
            "file": tempFile,
          });
        },
        onDone: () {
          controller.add({
            "status": "done",
            "message": "File read complete",
            "progress": "$totalChunks/$totalChunks",
            "file": tempFile,
          });
          controller.close();
          debugPrint("done");
        },
        onError: (error) {
          controller.add({
            "status": "error",
            "message": "Error reading file: ${error.toString()}",
            "progress": "",
            "file": tempFile,
          });
          controller.close();
          debugPrint("Error reading file: ${error.toString()}");
        },
      );
    });

    return controller.stream;
  }

  File? _generateTempFile() {
    final OsDirectories directories = ref.read(pathsProvider);
    final userInfo = ref.read(userInfoProvider);

    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(directories.tempDirectory.path);
    stringBuffer.write("/");
    stringBuffer.write(userInfo.uid);
    stringBuffer.write("/");
    // stringBuffer.write("");

    final random = Random();
    int randomNumber = 10000 + random.nextInt(99999 - 10000 + 1);
    stringBuffer.write(randomNumber.toString());
    stringBuffer.write(".tmp");

    final File tempFile = File(stringBuffer.toString());

    try {
      tempFile.parent.createSync(recursive: true); // Create parent directories if they don't exist
      return tempFile;
    } catch (e) {
      debugPrint("Failed to create parent directories for file: $e");
      return null;
    }
  }
}
