import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scb_pwd_mgr/service.dart';
import 'package:scb_pwd_mgr/widgets/Display/Display.dart';
import 'package:scb_pwd_mgr/widgets/History/History.dart';

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
    final res = await record(pwd);

    if (res == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Alread recored!'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }

    onUpdateHistory();
  }

  void onDelete(int index) async {
    await deleteItem(index);
    onUpdateHistory();
  }

  Future<void> onClearHistory() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Heads up!"),
          content: Text("Are you sure to clear history?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: () async {
                await clearHistory();
                onUpdateHistory();
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasHistory = history.length != 0;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            Display(content: pwd, onTap: onCopy),
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
            History(
              history: history,
              selectedIdx: selectedIdx,
              onTapTile: onTapTile,
              onDelete: onDelete,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40, top: 20),
              child: hasHistory
                  ? MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      child: Text(
                        'Clear History',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: onClearHistory,
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
