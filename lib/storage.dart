import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

const fileName = 'pwd.txt';

class Storage {
  static Storage _ins;

  static Storage get ins {
    return Storage._ins ?? (Storage._ins = new Storage());
  }

  Future<String> get _localPath async {
    Directory dir = await getApplicationDocumentsDirectory();

    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> readPwd() async {
    try {
      final file = await _localFile;
      List<String> contents = await file.readAsLines();

      return contents.last;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> readPwdHistory() async {
    try {
      final file = await _localFile;

      return file.readAsLines();
    } catch (e) {
      return [];
    }
  }

  Future<File> writePwd(String pwd) async {
    return writeFile(pwd + "\n", mode: FileMode.append);
  }

  Future<File> removeItemByIndex(int index) async {
    final list = await readPwdHistory();
    list.removeAt(list.length - 1 - index);

    return writeFile(list.join("\n") + "\n");
  }

  Future<File> clearHistory() async {
    return writeFile('');
  }

  Future<File> writeFile(String content,
      {FileMode mode = FileMode.write}) async {
    final file = await _localFile;

    return file.writeAsString(content, mode: mode);
  }
}
