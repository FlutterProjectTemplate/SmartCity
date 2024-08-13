import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'key_manager.dart';

class FileUtils {
  static Future<String> makeDirectory(String path) async {
    Directory directory = Directory("${await pathFolderApp()}/$path");
    if (directory.existsSync()) {
      return directory.path;
    } else {
      await directory.create(recursive: true);
    }
    return directory.path;
  }

  static Future<File> storeFileByByte(
      String path, String name, List<int> bytes) async {
    final file = File('$path/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static deleteFile(String path) async {
    File file = File("${await pathFolderApp()}/$path");
    if (!file.existsSync()) {
      throw Exception("This file is not exists");
    } else {
      file.delete(recursive: true);
    }
  }

  static deleteFolder(String path) async {
    Directory directory = Directory("${await pathFolderApp()}/$path");
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  }


  static Future<String> pathFolderApp() async =>
      "${(await getApplicationDocumentsDirectory()).path}/${KeyManager.getInstance().saveFileFolder}";

  static Future<File> storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    File file = await storeFileByByte(dir.path, filename, bytes);
    return file;
  }


  static String extensionFile(File file) {
    return extension(file.path);
  }

  static Uint8List getAvatar(String base64) {
    String data = base64.substring(
        base64.indexOf("base64,") + "base64,".length);
    Uint8List bytes = const Base64Codec().decode(data);
    return bytes;
  }

  static void printLog(dynamic log){
    if (kDebugMode) {
      print(log.toString());
      // Code here will only be included in debug mode.
      // As kDebugMode is a constant, the tree shaker
      // will remove the code entirely from compiled code.
    } else {

    }
  }
}
