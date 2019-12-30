import 'dart:math';

import 'package:scb_pwd_mgr/storage.dart';

const legalChars = [
  "abcdefghijklmnopqrstuvwxyz",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
  "0123456789",
  "!@#\$%^&*"
];

String generate({int len = 8, Storage storage}) {
  String newPwd = '';
  final totalLen = legalChars.length;

  while (newPwd.length < len) {
    final pi = Random().nextInt(totalLen - 1);
    final charSet = legalChars[pi];
    final ci = Random().nextInt(charSet.length - 1);
    newPwd += charSet[ci];
  }

  storage.writePwd(newPwd);

  return newPwd;
}
