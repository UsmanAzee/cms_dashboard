import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final pathsProvider = Provider<OsDirectories>((ref) => throw UnimplementedError());

Future<OsDirectories> getApplicationDirectories() async {
  Directory tempDirectory = await getTemporaryDirectory();
  Directory appDocumentsDirectory = tempDirectory;
  Directory appSupportDirectory = tempDirectory;
  Directory appLibraryDirectory = tempDirectory;
  Directory externalDocumentsDirectory = tempDirectory;
  List<Directory> externalStorageDirectories = [tempDirectory];
  List<Directory> externalCacheDirectories = [tempDirectory];
  Directory downloadsDirectory = tempDirectory;

  try {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  } catch (err) {
    debugPrint("Error getting application documents directory:\n${err.toString()}");
  }

  try {
    appSupportDirectory = await getApplicationSupportDirectory();
  } catch (err) {
    debugPrint("Error getting application support directory:\n${err.toString()}");
  }

  try {
    appLibraryDirectory = await getLibraryDirectory();
  } catch (err) {
    debugPrint("Error getting library directory:\n${err.toString()}");
  }

  try {
    externalDocumentsDirectory = await getExternalStorageDirectory() ?? tempDirectory;
  } catch (err) {
    debugPrint("Error getting external storage directory:\n${err.toString()}");
  }

  try {
    externalStorageDirectories = await getExternalStorageDirectories(type: StorageDirectory.music) ?? [tempDirectory];
  } catch (err) {
    debugPrint("Error getting external storage directories:\n${err.toString()}");
  }

  try {
    externalCacheDirectories = await getExternalCacheDirectories() ?? [tempDirectory];
  } catch (err) {
    debugPrint("Error getting external cache directories:\n${err.toString()}");
  }

  try {
    downloadsDirectory = await getDownloadsDirectory() ?? tempDirectory;
  } catch (err) {
    debugPrint("Error getting downloads directory:\n${err.toString()}");
  }

  return OsDirectories(
    tempDirectory: tempDirectory,
    appDocumentsDirectory: appDocumentsDirectory,
    appSupportDirectory: appSupportDirectory,
    appLibraryDirectory: appLibraryDirectory,
    externalDocumentsDirectory: externalDocumentsDirectory,
    externalStorageDirectories: externalStorageDirectories,
    externalCacheDirectories: externalCacheDirectories,
    downloadsDirectory: downloadsDirectory,
  );
}

class OsDirectories {
  final Directory tempDirectory;
  final Directory appDocumentsDirectory;
  final Directory appSupportDirectory;
  final Directory appLibraryDirectory;
  final Directory externalDocumentsDirectory;
  final List<Directory> externalStorageDirectories;
  final List<Directory> externalCacheDirectories;
  final Directory downloadsDirectory;
  // This is the path to android storage, the directories and folders
  // you see in a file manager in an android device
  final Directory androidExtDirectory = Directory("/storage/emulated/0");
  final Directory androidExtDownloadsDirectory = Directory("/storage/emulated/0/Download");

  OsDirectories({
    required this.tempDirectory,
    required this.appDocumentsDirectory,
    required this.appSupportDirectory,
    required this.appLibraryDirectory,
    required this.externalDocumentsDirectory,
    required this.externalStorageDirectories,
    required this.externalCacheDirectories,
    required this.downloadsDirectory,
  });
}
