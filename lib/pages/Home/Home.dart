import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scb_pwd_mgr/service.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String pwd = '';
  List<String> history = [];
  int selectedIdx = -1;

  @override
  void initState() {
    super.initState();

    readPwd().then((persistPwd) => setState(() => pwd = persistPwd));
    onUpdateHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: GestureDetector(
                onTap: onCopy,
                child: Tooltip(
                  message: 'Tap to copy',
                  child: Text(
                    pwd,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text(
                    'Generate',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Colors.green,
                  onPressed: onRegenerate,
                ),
                MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  child: Text(
                    'Record',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                  onPressed: onRecord,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 22, bottom: 22),
                        child: Text(
                          'History',
                          style: TextStyle(color: Colors.green, fontSize: 28),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: history.length,
                        itemBuilder: (BuildContext context, int index) {
                          final content = history[index];

                          return ListTile(
                            key: Key(content),
                            title: Text(content),
                            onTap: () => onTapTile(content, index),
                            trailing: selectedIdx != index
                                ? null
                                : Text(
                                    'Copied',
                                    style: TextStyle(color: Colors.green),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40, top: 20),
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Text(
                  'Clear History',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: onClearHistory,
              ),
            )
          ],
        ),
      ),
    );
  }

  onRegenerate() async {
    final newPwd = generate();

    setState(() => pwd = newPwd);

    onUpdateHistory();
  }

  void onUpdateHistory() async {
    final _h = await readPwdHistory();

    setState(() => history = _h);
  }

  void onTapTile(String content, int index) {
    onCopy(content: content);

    setState(() => selectedIdx = index);
    Timer(Duration(milliseconds: 1300), () {
      setState(() => selectedIdx = -1);
    });
  }

  void onCopy({String content}) {
    Clipboard.setData(ClipboardData(text: content ?? pwd));

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "Password has been copied!",
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 1000),
      backgroundColor: Colors.green,
    ));
  }

  void onRecord() async {
    await record(pwd);
    onUpdateHistory();
  }

  void onClearHistory() async {
    await clearHistory();
    onUpdateHistory();
  }
}
