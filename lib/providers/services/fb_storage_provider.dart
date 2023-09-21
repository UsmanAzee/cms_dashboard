import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'paths_provider.dart';
import 'user_info_provider.dart';

final fbStorageProvider = NotifierProvider<FBStorageUtils, FirebaseStorage>(() => FBStorageUtils());

enum StreamStatus {
  running,
  paused,
  success,
  canceled,
  error,
}

class UserStorage {
  static const String profileImage = "/profile_image";
}

class FBStorageUtils extends Notifier<FirebaseStorage> {
  static const String bucketPathHttps = "https://firebasestorage.googleapis.com/b/fl-riverpod.appspot.com/o";
  static const String bucketPathGs = "gs://fl-riverpod.appspot.com";

  static const String bucketPath = bucketPathGs;

  static const int oneMegabyte = 1024 * 1024;

  @override
  FirebaseStorage build() => FirebaseStorage.instance;

  Stream<List<dynamic>> uploadFileToFirebaseStorage(String cloudFilePath, {Uint8List? data, File? file}) {
    final OsDirectories directories = ref.watch(pathsProvider);
    final UserInfoUtils userUtils = ref.watch(userInfoProvider.notifier);

    final controller = StreamController<List<dynamic>>();

    StringBuffer buffer = StringBuffer();
    buffer.write(bucketPath);
    buffer.write("/user_${userUtils.state.uid}");
    buffer.write(cloudFilePath);
    final Reference fsFileRef = state.refFromURL(buffer.toString());

    if (file == null && data == null) {
      controller.add([StreamStatus.error]);
      controller.close();
      return controller.stream;
    }

    if (data == null) {
      // File object is available
    } else if (file == null) {
      final String filePath = "${directories.tempDirectory.path}/user$cloudFilePath";
      file = File(filePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsBytesSync(data);
      }
    }

    // Initialize the upload
    final uploadTask = fsFileRef.putFile(file!);

    // Listen to the upload task's state changes
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      switch (snapshot.state) {
        case TaskState.running:
          controller.add([StreamStatus.running, file, fsFileRef]);
          break;
        case TaskState.paused:
          controller.add([StreamStatus.paused, file, fsFileRef]);
          break;
        case TaskState.success:
          controller.add([StreamStatus.success, file, fsFileRef]);
          break;
        case TaskState.canceled:
          controller.add([StreamStatus.canceled, file, fsFileRef]);
          break;
        case TaskState.error:
          controller.add([StreamStatus.error, file, fsFileRef]);
          break;
        default:
          break;
      }
    });

    // Complete the stream when the upload is complete
    uploadTask.whenComplete(() {
      controller.close();
    });

    return controller.stream;
  }

  Future<void> uploadUserFile(String userBucket, String cloudFilePath, {Uint8List? data, File? file}) async {
    final Stream<List<dynamic>> stream = uploadFileToFirebaseStorage("/$cloudFilePath", file: file, data: data);

    // Create a completer to convert the stream to a future
    final completer = Completer<List<dynamic>>();

    stream.listen((List<dynamic> result) {
      if (result.first != StreamStatus.running) {
        completer.complete(result);
      }
    });
  }

  // Downloads the file data to memory and returns
  Future<Uint8List?> getMFileFromFirebaseStorage(String cloudFilePath) async {
    final Reference fsFileRef = state.refFromURL("$bucketPath$cloudFilePath");
    const oneMegabyte = 1024 * 1024;
    final Uint8List? downloadedData = await fsFileRef.getData(oneMegabyte * 10);
    return downloadedData;
  }

  // Downloads the file data to local storage and returns
  Stream<List<dynamic>> getFileFromFirebaseStorage(String cloudFilePath, bool useLocalStorage) {
    // get dependency providers
    final OsDirectories directories = ref.watch(pathsProvider);
    final UserInfoUtils userUtils = ref.watch(userInfoProvider.notifier);

    // Create a controller for the stream
    final controller = StreamController<List<dynamic>>();

    // Unique user folder name (a bucket for every user)
    String userFolderName = "/user_${userUtils.state.uid}";

    // Make a new local file in application documents directory to hold the downloaded data
    final String filePath = "${directories.appDocumentsDirectory.path}$userFolderName$cloudFilePath";
    File file = File(filePath);

    if (file.existsSync() && useLocalStorage) {
      // if file already exists in storage, read and return the file
      controller.add([StreamStatus.success, file]);
      controller.close();
      return controller.stream;

      // // If file already exists, add a number suffix
      // int suffix = 1;
      // String fileName = file.path.split('/').last;
      // String fileNameWithoutExtension = fileName.substring(0, fileName.lastIndexOf('.'));
      // String fileExtension = fileName.substring(fileName.lastIndexOf('.'));
      //
      // while (file.existsSync()) {
      //   String newFileName = '${fileNameWithoutExtension}_$suffix$fileExtension';
      //   file = File('${file.parent.path}/$newFileName');
      //   suffix++;
      // }
    } else {
      // if file does not exists, create one
      file.createSync(recursive: true);
    }

    StringBuffer buffer = StringBuffer();
    buffer.write(bucketPath);
    buffer.write(userFolderName);
    buffer.write(cloudFilePath);
    final Reference fsFileRef = state.refFromURL(buffer.toString());

    final DownloadTask downloadTask = fsFileRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          controller.add([StreamStatus.running, file, fsFileRef]);
          break;
        case TaskState.paused:
          controller.add([StreamStatus.paused, file, fsFileRef]);
          break;
        case TaskState.success:
          controller.add([StreamStatus.success, file, fsFileRef]);
          break;
        case TaskState.canceled:
          controller.add([StreamStatus.canceled, file, fsFileRef]);
          break;
        case TaskState.error:
          controller.add([StreamStatus.error, file, fsFileRef]);
          break;
        default:
          break;
      }
    });

    // Complete the stream when the upload is complete
    downloadTask.whenComplete(() {
      controller.close();
    });

    return controller.stream;
  }

  Future<File?> getFileDataFromFirebaseStorage(String cloudFilePath, bool useCache) async {
    final Stream<List<dynamic>> stream = getFileFromFirebaseStorage(cloudFilePath, useCache);

    // Create a completer to convert the stream to a future
    final completer = Completer<File?>();

    stream.listen((event) {
      final List<dynamic> data = event;
      final StreamStatus status = data.first;

      if (status != StreamStatus.running) {
        completer.complete(data.last);
      }
    });

    return completer.future;
  }
}
