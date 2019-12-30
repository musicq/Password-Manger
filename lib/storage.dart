import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/pwd.txt');
  }

  Future<String> readPwd() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writePwd(String pwd) async {
    final file = await _localFile;

    return file.writeAsString(pwd);
  }
}
