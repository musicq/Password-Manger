import 'dart:io';
import 'dart:math';

import 'package:scb_pwd_mgr/storage.dart';

const legalChars = [
  "abcdefghijklmnopqrstuvwxyz",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "0123456789",
  "!@#\$%^&*"
];

Future<String> readPwd() async {
  String pwd;

  pwd = await Storage.ins.readPwd();

  if (pwd == null) {
    pwd = generate();
  }

  return pwd;
}

String generate({int len = 8}) {
  String newPwd = '';
  final totalLen = legalChars.length;
  // Record if new password contains all the necessary characters.
  final containCharsSet = Set();

  while (newPwd.length < len) {
    final pi = Random().nextInt(totalLen);
    containCharsSet.add(pi);

    final charSet = legalChars[pi];
    final ci = Random().nextInt(charSet.length);
    newPwd += charSet[ci];
  }

  if (containCharsSet.length < legalChars.length) {
    return generate(len: len);
  }

  return newPwd;
}

Future<File> record(String content) async {
  final lastPwd = await readPwd();
  if (lastPwd == content) {
    return null;
  }

  return await Storage.ins.writePwd(content);
}

Future<List<String>> readPwdHistory() async {
  final history = await Storage.ins.readPwdHistory();
  return history.reversed.toList();
}

Future<File> clearHistory() async {
  return Storage.ins.clearHistory();
}

Future<File> deleteItem(int index) async {
  return Storage.ins.removeItemByIndex(index);
}
